Sub The_VBA_of_Wall_Street()'TERRENCE CUMMINGS'VBA HOMEWORK - HARD  'Loop through ticker symbols and capture        'Ticker symbol        'Starting date and opening price        'Ending date and closing price        'Calc yearly amount change in price        'Calc yearly % change in price        'Format change as green if positive and red if negative        'Calc sum of total stock volume traded in the year    'Identify the ticker symbols with following stats and make a summary table of the ticker symbol and these values        'Greatest % increase        'Greatest % decrease        'Greatest total volume    Dim sht As Worksheet    Dim LastRow As Long    Dim LastColumn As Long    Dim Ticker_Symbol As String    Dim Start_Date As Long    Dim Start_Open_Price As Double    Dim Total_Volume As Double    Dim End_Date As Long    Dim End_Close_Price As Double    Dim Max_Incr As Double    Dim Max_Decr As Double    Dim Max_Vol As Double    Dim Max_Incr_Ticker As String    Dim Max_Decr_Ticker As String    Dim Max_Vol_Ticker As String       'Go through all the Worksheets in the Workbook    For x = 1 To Application.Sheets.Count        Sheets(x).Activate    Set sht = ActiveSheet        MsgBox "The name of the active sheet is " & ActiveSheet.Name        'clear any prior results    Columns("H:W").Select    Selection.Clear        'Initialize tracker variables for max increase, decrease, and volume    Max_Incr = 0    Max_Decr = 0    Max_Vol = 0    'Find number of rows and columns of data including header    LastRow = sht.Cells(sht.Rows.Count, "A").End(xlUp).Row    LastColumn = sht.Cells(1, sht.Columns.Count).End(xlToLeft).Column        'Ensure data is sorted by ascending ticker symbol and then ascending date    Range(Cells(1, 1), Cells(LastRow, LastColumn)).Sort key1:=Range("A1"), order1:=xlAscending, key2:=Range("B2"), order2:=xlAscending, Header:=xlYes        'Build output tables headers    Cells(1, LastColumn + 2).Value = "Ticker"    Cells(1, LastColumn + 3).Value = "Yearly Change"    Cells(1, LastColumn + 4).Value = "Percent Change"    Cells(1, LastColumn + 5).Value = "Total Stock Volume"    Cells(1, LastColumn + 9).Value = "Ticker"    Cells(1, LastColumn + 10).Value = "Value"    Cells(2, LastColumn + 8).Value = "Greatest % Increase"    Cells(3, LastColumn + 8).Value = "Greatest % Decrease"    Cells(4, LastColumn + 8).Value = "Greatest Total Volume"        'counter for number of unique ticker symbols    Number_of_Tickers = 0    For i = 2 To LastRow 'do for each entry        'If this is the first occurence of this ticker symbol record the ticker symbol, start date, and start price, and reset total volume        If Cells(i, 1).Value <> Cells(i - 1, 1).Value Then            Number_of_Tickers = Number_of_Tickers + 1            Ticker_Symbol = Cells(i, 1).Value            Start_Date = Cells(i, 2).Value            Start_Open_Price = Cells(i, 3).Value            Total_Volume = 0        End If                'Add up volume to get total volume (resets to zero when new ticker symbol encountered)        Total_Volume = Total_Volume + Cells(i, 7).Value               'If this is the last occurrence of the ticker symbol record the end date, end price and add this ticker symbol's data to the tables        If Cells(i, 1).Value <> Cells(i + 1, 1).Value Then            End_Date = Cells(i, 2).Value            End_Close_Price = Cells(i, 6).Value            'fill and format ticker symbol summary table            Cells(1 + Number_of_Tickers, LastColumn + 2).Value = Ticker_Symbol            Cells(1 + Number_of_Tickers, LastColumn + 3).Value = End_Close_Price - Start_Open_Price            Cells(1 + Number_of_Tickers, LastColumn + 3).NumberFormat = "0.00"            'control for divide by zero            If Start_Open_Price <> 0 Then                Pct_Change = (End_Close_Price - Start_Open_Price) / (Start_Open_Price)            Else                Pct_Change = 0            End If            Cells(1 + Number_of_Tickers, LastColumn + 4).Value = Pct_Change            Cells(1 + Number_of_Tickers, LastColumn + 4).NumberFormat = "0.00%"            'format cell interior as red for price decrease, green for price increase from start to end of year            If End_Close_Price - Start_Open_Price < 0 Then                Cells(1 + Number_of_Tickers, LastColumn + 3).Interior.ColorIndex = 3                Cells(1 + Number_of_Tickers, LastColumn + 4).Interior.ColorIndex = 3            Else                Cells(1 + Number_of_Tickers, LastColumn + 3).Interior.ColorIndex = 4                Cells(1 + Number_of_Tickers, LastColumn + 4).Interior.ColorIndex = 4            End If            Cells(1 + Number_of_Tickers, LastColumn + 5).Value = Total_Volume                        'check for max increase, decrease, and volume            If Pct_Change < Max_Decr Then                Max_Decr = Pct_Change                Max_Decr_Ticker = Ticker_Symbol            End If            If Pct_Change > Max_Incr Then                Max_Incr = Pct_Change                Max_Incr_Ticker = Ticker_Symbol            End If            If Total_Volume > Max_Vol Then                Max_Vol = Total_Volume                Max_Vol_Ticker = Ticker_Symbol            End If                    End If                      Next i          'Write out max incr, decr and vol stats    Cells(2, LastColumn + 9).Value = Max_Incr_Ticker    Cells(3, LastColumn + 9).Value = Max_Decr_Ticker    Cells(4, LastColumn + 9).Value = Max_Vol_Ticker    Cells(2, LastColumn + 10).Value = Max_Incr    Cells(3, LastColumn + 10).Value = Max_Decr    Cells(4, LastColumn + 10).Value = Max_Vol    Cells(2, LastColumn + 10).NumberFormat = "0.00%"    Cells(3, LastColumn + 10).NumberFormat = "0.00%"    Cells(4, LastColumn + 10).NumberFormat = "General"    sht.Columns.AutoFit        'Checksum on original and summary total volume to see if missed anything    Total_Volume_Orig = Application.WorksheetFunction.Sum(Range("G:G"))    Total_Volume_Summary = Application.WorksheetFunction.Sum(Range("L:L"))    If Total_Volume_Orig = Total_Volume_Summary Then        MsgBox ("Check sum is OK!")    Else        MsgBox ("Oops! Check sum is NOT OK!")    End If        Next x    MsgBox ("Finished!")End Sub