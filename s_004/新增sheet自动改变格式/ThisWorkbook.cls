VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    On Error Resume Next
    Call CopySheetsNames
    Call CopySheetName
End Sub

Private Sub Workbook_NewSheet(ByVal Sh As Object)
    On Error Resume Next
    Call MoveCr
    Call CopySheetName
End Sub

Private Sub Workbook_Open()

End Sub
