Suki = require('../build/suki.test')()

describe 'Base', ->
  describe '.include', ->
    it 'should extend prototype', ->
      obj =
        prototype:
          name: 'Bob'
      Suki.Base.include obj
      Suki.Base::.name.should.eql 'Bob'

    it 'should ignore the `constructor`', ->
      obj =
        prototype:
          constructor: 'Bob'
      Suki.Base.include obj
      Suki.Base::.constructor.should.not.eql 'Bob'

  describe '.getter & .setter', ->
    describe '.getter', ->
      it 'should define a instance getter', ->
        Suki.Base.getter 'baseName', -> 'Bob'
        base = new Suki.Base()
        base.baseName.should.eql 'Bob'

    describe '.setter', ->
      it 'should define a instance setter', ->
        baseName = 'Jeff'
        Suki.Base.setter 'baseName', (value) -> baseName = value
        base = new Suki.Base()
        base.baseName = 'Bob'
        baseName.should.eql 'Bob'

    it 'should work well with both getter and setter are defined', ->
      baseName = 'Jeff'
      Suki.Base.getter 'baseName', -> baseName
      Suki.Base.setter 'baseName', (value) -> baseName = value
      base = new Suki.Base()
      base.baseName.should.eql 'Jeff'
      base.baseName = 'Bob'
      baseName.should.eql 'Bob'

  describe '#id', ->
    it 'should return a UUID', ->
      base1 = new Suki.Base()
      base2 = new Suki.Base()
      base1.id.should.be.a.String
      base2.id.should.be.a.String
      base1.id.should.not.eql base2.id
      base1.id.should.eql base1.id

    it 'should contain the name of the constructor', ->
      base = new Suki.Base()
      base.id.should.include 'Base'
      event = new Suki.Event()
      event.id.should.include 'Event'

