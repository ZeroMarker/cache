function ImportEquipCat()
{
	
}

function CloseExcel(xlBook,xlApp,xlsheet)
{
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
}

