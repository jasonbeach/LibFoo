#include <iostream>
#include "foo.hpp"


int Foo::get_number()
{
  return number_;
}
  
void Foo::set_number(int num)
{
  number_ = num;
}
  
void Foo::print_number()
{
  std::cout << "The number is: " << number_ << std::endl;
}