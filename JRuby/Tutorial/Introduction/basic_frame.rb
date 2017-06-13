# This example shows a simple
# window in the center of the screen.

include Java

import javax.swing.JFrame

class BasicFrame < JFrame

  def initialize
    super "Simple"
    self.initUI
  end

  def initUI
    self.setSize(300, 200)
    self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    self.setLocationRelativeTo(nil)
    self.setVisible(true)
  end
end

BasicFrame.new
