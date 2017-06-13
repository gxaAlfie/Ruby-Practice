# This code shows a tooltip on
# a window and a button

include Java

import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JPanel

class TooltipFrame < JFrame

  def initialize
    super "Tooltips"
    self.initUI
  end

  def initUI
    panel = JPanel.new
    self.getContentPane.add(panel)
    panel.setLayout(nil)
    panel.setToolTipText "A panel container"

    button = JButton.new("Button")
    button.setBounds(100, 60, 100, 30)
    button.setToolTipText("A button component")

    panel.add(button)

    self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    self.setSize(300, 200)
    self.setLocationRelativeTo(nil)
    self.setVisible(true)
  end

end

TooltipFrame.new
