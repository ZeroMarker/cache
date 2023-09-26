function printpatinfro(){
	var Objtbl=document.getElementById('tUDHCJFinfro');
	var Rownum=Objtbl.rows.length;
	if (Rownum<2) return;
	var row=1
    var getnum=document.getElementById('getnum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	var	patnum=cspRunServerMethod(encmeth,"","")
    var xlApp,obook,osheet,xlBook
    var Template,p2
    var a=0
	Template="d:\UDHCry.xls"
    //Template=path+"UDHJFCry.xls"  
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
    var n=Math.floor((patnum-1)/41)
    var m=(patnum-1)%41
    for(a=0;a<n;a++){		
       for(i=1;i<=41;i++){
  		  p2=a*41+i	          
		  var getdata=document.getElementById('getdata');
		      if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
		          var str=cspRunServerMethod(encmeth,'','',p2);
		          myData1=str.split("^")                   
                  printDetail()
                  xlsheet.cells(2,6)=t['03']+stdateobj+t['04']+enddateobj                  
              }   
          xlsheet.printout
          clearall(xlsheet) 
       }
       if(m!=0){
	      for(i=1;i<=m;i++){	
  			  p2=n*41+i	          
		      var getdata=document.getElementById('getdata');
		      if (getdata) {
			      var encmeth=getdata.value} else {var encmeth=''};		           
		          var str=cspRunServerMethod(encmeth,'','',p2);		          
		          myData1=str.split("^")             
                  printDetail()
                  xlsheet.cells(2,6)=t['03']+stdateobj+t['04']+enddateobj
              }
         } 
                  
          xlsheet.cells(i+3,1)=t['05']
          xlsheet.cells(i+3,6)=t['06']+datetoday
	      //xlBook.SaveAs("C:\\PatAdmInfo"+".xls");   //lgl+
	      //xlBook.Close (savechanges=false);
	      xlsheet.printout 
     	  xlBook.Close (savechanges=false);
	      xlApp.Quit();
	      xlApp=null;
	      xlsheet=null	 
    }
function printDetail(){
	 for (j=1;j<=8;j++){
	     xlsheet.cells(i+3,j)=myData1[j]
   	     addgrid(xlsheet,0,0,1,7,i+2,1)
	 }
}

function addgrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft){
         objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
         objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
         objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
         objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}
function clearall(objSheet){
	for(i=4;i<=44;i++){
		for(j=1;j<=16;j++){
			xlsheet.cells(i+1,j)=""
		}
	    objSheet.Range(objSheet.Cells(i, 1), objSheet.Cells(i+1, 16)).Borders(1).LineStyle=0;
 	    objSheet.Range(objSheet.Cells(i, 1), objSheet.Cells(i+1, 16)).Borders(2).LineStyle=0;
 	    objSheet.Range(objSheet.Cells(i, 1), objSheet.Cells(i+1, 16)).Borders(3).LineStyle=0;
 	    objSheet.Range(objSheet.Cells(i, 1), objSheet.Cells(i+1, 16)).Borders(4).LineStyle=0;	
    }
}
function PrintWorkLoadNX()
{
	var Objtbl=document.getElementById('tUDHCJFWorkLoad');
	var Rownum=Objtbl.rows.length;
	if (Rownum<2) return;
	var row=1
    var getnum=document.getElementById('getnum');
	if (getnum) {
		var encmeth=getnum.value
	} 
	else {
		var encmeth=''
    }
    var	patnum=cspRunServerMethod(encmeth,"","")
    //alert(patnum)
    var xlApp,obook,osheet,xlBook
    var Template,p2
    var a=0
    //Template="d:\UDHCJF_Deposituser.xls"
    Template=path+"UDHJFCry.xls"  
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
    var n=Math.floor(patnum/41)
    var m=(patnum)%41
    for(a=0;a<n;a++){		
       for(i=1;i<=41;i++){
  		  p2=a*41+i         
		  var getdata=document.getElementById('getdata');
		      if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
		          var str=cspRunServerMethod(encmeth,'','',p2);
		          myData1=str.split("^")                   
                  printDetailwork()                   
              }   
           xlsheet.printout
           clearall(xlsheet) 
        }
       if(m!=0){
	      for(i=1;i<=m;i++){	
  			  p2=n*41+i          
		      var getdata=document.getElementById('getdata');
		      if (getdata) {
			      var encmeth=getdata.value
			  }
			  else {
				  var encmeth=''
			  }		           
		      var str=cspRunServerMethod(encmeth,'','',p2);		          
		      myData1=str.split("^")             
              printDetailwork()
              xlsheet.cells(2,7)=stdate+t['zhi']+enddate 
           }
        }
        xlsheet.cells(i+3,1)=t['zbren'] 
        xlsheet.cells(i+3,7)=t['zbdate'] 
        xlsheet.cells(i+3,8)=datetoday
        alert(datetoday) 
		xlsheet.printout 
     	xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null
}
function printDetailwork(){
	 for (j=0;j<=7;j++){
	     xlsheet.cells(i+3,j+2)=myData1[j]
   	     addgrid(xlsheet,0,0,1,7,i+2,1)
	 }
}

