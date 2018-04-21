class HelloService
  def initialize(language)
    @word = language.to_sym == :ru ? 'Привет!' : 'Hello!'
  end

  def say
    puts @word
  end
end