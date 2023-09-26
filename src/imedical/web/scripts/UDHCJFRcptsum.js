

function BodyLoadHandler() {

    //alert("111111111111");
	var obj=document.getElementById("Export");
	if (obj){ obj.onclick=Export_click;}	

	
	}
	
	
function Export_click()
{
		try {
	  var xlApp,xlsheet,xlBook

	  //StrTBBZ=GetTBBZ()

	  //path="http://192.16.2.1/dthealth/med/results/template/"
	  //path="c:\\moban\\"
	  path=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","")
       
	  var Template=path+"JF_Rcptsum.xls"
	  
	  xlApp = new ActiveXObject("Excel.Application");
	  xlBook = xlApp.Workbooks.Add(Template);
	  xlsheet = xlBook.ActiveSheet
	    xlsheet.PageSetup.LeftMargin=0;  
	    xlsheet.PageSetup.RightMargin=0;
	  
	  var objtbl=document.getElementById("tUDHCJFRcptsum");
		var Rows=objtbl.rows.length; 
		var xlsrow=3;
		var xlsCurcol=1;
		var myRows=Rows;

    var date=new Date();
	var year=date.getYear();
	var month=date.getMonth()+1;
	var day=date.getDate()
	var time=year+"-"+month+"-"+day


	
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;
		
			var listobj=document.getElementById('TCashierz'+Row);
			if (listobj){var myval=listobj.innerText;
			var myusercode=document.getElementById('TCasherNoz'+Row).innerText;
		   xlsheet.cells(xlsrow,xlsCurcol+1)=myusercode+" "+myval;
				//xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
		   xlsheet.cells(xlsrow,xlsCurcol+1).Borders(9).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+1).Borders(7).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+1).Borders(10).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+1).Borders(8).LineStyle = 1
			}

			var listobj=document.getElementById("TrcptNoz"+Row);
			var myval=listobj.innerText;
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
		   xlsheet.cells(xlsrow,xlsCurcol+2).Borders(9).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+2).Borders(7).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+2).Borders(10).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+2).Borders(8).LineStyle = 1

			var listobj=document.getElementById("TrcptNumz"+Row);
			var myval=listobj.innerText;
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
		   xlsheet.cells(xlsrow,xlsCurcol+3).Borders(9).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+3).Borders(7).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+3).Borders(10).LineStyle = 1
           xlsheet.cells(xlsrow,xlsCurcol+3).Borders(8).LineStyle = 1

			var listobj=document.getElementById("Trcptsumz"+Row);
			if (listobj){
				var myval=listobj.innerText;
				xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
		        xlsheet.cells(xlsrow,xlsCurcol+4).Borders(9).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+4).Borders(7).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+4).Borders(10).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+4).Borders(8).LineStyle = 1
			}
			
			var listobj=document.getElementById("Trcptnozfz"+Row);
			if (listobj){
				var myval=listobj.innerText;
				xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
		        xlsheet.cells(xlsrow,xlsCurcol+5).Borders(9).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+5).Borders(7).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+5).Borders(10).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+5).Borders(8).LineStyle = 1
			}
	
			var listobj=document.getElementById("Trcptnumzfz"+Row);
			var myval=listobj.innerText;
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
		        xlsheet.cells(xlsrow,xlsCurcol+6).Borders(9).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+6).Borders(7).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+6).Borders(10).LineStyle = 1
                xlsheet.cells(xlsrow,xlsCurcol+6).Borders(8).LineStyle = 1


		}

		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
			   
	    xlsheet.printout;
    
         xlBook.Close (savechanges=false);
	     xlApp.Quit();
	     xlApp=null;
  	     xlsheet=null	
	    
	} catch(e) {
		alert(e.message);
	};

	
	
	}	
	
	
	
document.body.onload = BodyLoadHandler;