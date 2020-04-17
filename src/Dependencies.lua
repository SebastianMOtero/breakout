-- https://github.com/Ulydev/push
push = require 'lib/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

require 'src/constants'
require 'src/StateMachine'
require 'src/Util'
require 'src/Paddle'
--states
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'