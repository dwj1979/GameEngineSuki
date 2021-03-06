Suki = require('../build/suki.test')()

describe 'Scene', ->
  describe '.current', ->
    describe 'without any scenes active', ->
      it 'should create a new scene', ->
        scene = Suki.Scene.current
        scene.should.be.an.instanceof Suki.Scene
        scene.type is Suki.Scene._defaultSceneType

    describe 'with at least one scene beening active', ->
      before ->
        Suki.Scene.define 'Scene1'

      it 'should return the last created scene', ->
        scene = Suki.Scene.create 'Scene1'
        Suki.Scene.current.should.eql scene

  describe '.create', ->
    describe 'when has not been defined', ->
      it 'should throw when the type of scene has not been defined', ->
        (-> Suki.Scene.create 'NoSuchType').should.throw /before created/

    describe 'when has been defined', ->
      it 'should trigger a global event `EnterFrame`', (done) ->
        scene = Suki.Scene.create 'Scene1'
        scene.one 'EnterFrame', ->
          done()

      it 'should trigger a global event `BeforeDraw`', (done) ->
        scene = Suki.Scene.create 'Scene1'
        scene.one 'BeforeDraw', ->
          done()

      it 'should trigger a global event `CreateScene`', (done) ->
        event = new Suki.Event()
        event.one 'CreateScene', ->
          done()
        scene = Suki.Scene.create 'Scene1'

      it 'should destroy the current scene before a new scene beening created', (done) ->
        triggeredBeforeSceneDestroy = false
        Suki.Scene.define 'OldScene', null, ->
          triggeredBeforeSceneDestroy.should.be.true
          done()

        oldScene = Suki.Scene.create 'OldScene'
        oldScene.bind 'DestroyScene', ->
          triggeredBeforeSceneDestroy = true

        newScene = Suki.Scene.create 'Scene1'

  describe '#destroy', ->
    it 'should destroy the timer when beening destroyed', ->
      currentScene = Suki.Scene.current
      currentScene.destroy()
      currentScene.frameTimer.paused.should.be.true

    it 'should destroy all layers', (done) ->
      Suki.Scene.define 'TestLayers', ->
        layer = Suki.Layer.current

        event = new Suki.Event()
        event.one 'DestroyLayer', ->
          done()

      scene = Suki.Scene.create 'TestLayers'
      scene.destroy()

    it 'should trigger a global event `DestroyScene`', (done) ->
      event = new Suki.Event()
      event.one 'DestroyScene', ->
        done()
      Suki.Scene.current.destroy()

    it 'should remove the layer from the #layers which is destroyed', ->
      Suki.Layer.define 'Layer'
      Suki.Scene.define 'TestLayers', ->
        layer1 = Suki.Layer.create 'Layer'
        layer2 = Suki.Layer.create 'Layer'
        @layers.should.have.lengthOf 2
        layer2.destroy()
        @layers.should.have.lengthOf 1
        @layers[0].should.eql layer1

      scene = Suki.Scene.create 'TestLayers'

