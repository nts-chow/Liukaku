Attribute VB_Name = "Module1"
Option Explicit
Sub MoveCr()
    On Error Resume Next
    ActiveCell.Columns("A:A").EntireColumn.ColumnWidth = 2.5
    ActiveWindow.Zoom = 85
    ActiveCell.Offset(1, 1).Range("A1").Select
    ActiveWindow.FreezePanes = True
End Sub

Sub CopySheetName()
    On Error Resume Next
    Cells(1, 2) = ActiveSheet.name
    Cells(1, 2).Font.Bold = True
End Sub

Sub CopySheetsNames()
    On Error Resume Next
    Dim sht As Worksheet
    For Each sht In Sheets
        If sht.name <> ActiveSheet.name Then
            sht.Cells(1, 2) = sht.name
            Cells(1, 2).Font.Bold = True
        End If
    Next
End Sub
