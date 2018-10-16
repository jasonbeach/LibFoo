#pragma once

class Foo
{
public:
  int get_number();
  void set_number(int num);
  void print_number();

private:
  int number_{0};
};