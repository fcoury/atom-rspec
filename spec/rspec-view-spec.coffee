RspecView = require '../lib/rspec-view'
{WorkspaceView} = require 'atom'

describe "RspecView", ->
  it "has one valid test", ->
    expect("life").toBe "easy"
