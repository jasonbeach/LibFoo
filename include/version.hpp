#pragma once

#include <string>

namespace version
{
std::string full();
unsigned major();
unsigned minor();
unsigned patch();
unsigned tweak();
std::string git_hash();

}