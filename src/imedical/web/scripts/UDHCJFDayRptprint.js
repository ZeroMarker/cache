function nyfydeptprint(){
	Template="C:\JF_DeptRpt.xls"

    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet  

	
	guser=session['LOGON.USERID']
	
	var dataobj=document.getElementById("getdata"); 

	if (dataobj) {var encmeth=dataobj.value} else {var encmeth=''};
	var data=cspRunServerMethod(encmeth,guser);

	if (data=="")  return ;
	var data1=data.split("@")
	
	var data2=data1[1].split("^")
	
	xlsheet.cells(7,2).value=data2[0]
	xlsheet.cells(7,4).value=data2[3]
	xlsheet.cells(7,5).value=data2[4]
	xlsheet.cells(7,6).value=data2[5]
	xlsheet.cells(7,7).value=data2[6]
	xlsheet.cells(7,8).value=data2[1]
	xlsheet.cells(7,9).value=data2[2]
	xlsheet.cells(7,10).value=data2[10]
	xlsheet.cells(7,3).value=data2[9]
	
	var rows=9
	
	var data3=data1[0].split("!")
	
    for (j=0;j<=data3.length-1;j++){
	    if (data3[j]!=""){
	    var str=data3[j].split("^")
	    xlsheet.Range(xlsheet.Cells(rows, 4), xlsheet.Cells(rows,5)).MergeCells =1;
	    xlsheet.Range(xlsheet.Cells(rows, 6), xlsheet.Cells(rows,7)).MergeCells =1;
	    xlsheet.Range(xlsheet.Cells(rows, 8), xlsheet.Cells(rows,9)).MergeCells =1;
	   
	    xlsheet.cells(rows,2).value=str[0]
	    xlsheet.cells(rows,3).value=str[1]
	    xlsheet.cells(rows,4).value=str[2]
	    xlsheet.cells(rows,6).value=str[3]
	    xlsheet.cells(rows,8).value=str[4]
	    xlsheet.cells(rows,10).value=str[5]
	   
	    rows=rows+1
	    }
 
	    }

	 
	 xlsheet.Range(xlsheet.Cells(rows, 2), xlsheet.Cells(rows,7)).MergeCells =1;
	 xlsheet.Range(xlsheet.Cells(rows, 8), xlsheet.Cells(rows,9)).MergeCells =1;
	 xlsheet.cells(rows,2).value="    ºÏ¼Æ£º"
	 xlsheet.cells(rows,8).value=data2[7]
	 xlsheet.cells(rows,10).value=data2[8]
	 
	 AddGrid(xlsheet,9,2,rows,10,9,2)
	 xlsheet.printout
     xlBook.Close (savechanges=false);
     xlApp=null;
     xlsheet=null 
	 
	}

function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
    {        
            objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
            objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
            objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
            objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
     }  
function GetJsYjRowid()
{
	var Objtbl=parent.frames['UDHCJFDepositRpt'].document.getElementById('tUDHCJFDepositRpt');
	var Rows=Objtbl.rows.length;
	var paymodestr
	paymodestr=t['jstpaymode'].split("_")
	yjrowid=""
	rcptrow=Rows
	for (i=1;i<=Rows-2;i++)
	{  
	   var select=true
	   SelRowObj=parent.frames['UDHCJFDepositRpt'].document.getElementById('Trowidz'+i);
	   var prtrowid=SelRowObj.innerText;	   
	   if ((yjrowid!="")&&(select==true))
	   {yjrowid=yjrowid+"^"+prtrowid}	   
	   if ((yjrowid=="")&&(select==true))
	   {yjrowid=prtrowid}     
	   }
}
function GetJsFpRowid()
{   fprowid=""
	var Objtbl=parent.frames['UDHCJFdayInvRpt'].document.getElementById('tUDHCJFdayInvRpt');
	var Rows=Objtbl.rows.length;
	
	//invrow=Rows-1
	invrow=Rows
	
	for (i=1;i<=Rows-2;i++)
	{  
	   var select=true
	   SelRowObj=parent.frames['UDHCJFdayInvRpt'].document.getElementById('Trowidz'+i);
	   var prtrowid=SelRowObj.innerText;
	   if ((fprowid!="")&&(select==true))
	   {fprowid=fprowid+"^"+prtrowid}
	   if ((fprowid=="")&&(select==true))
	   {fprowid=prtrowid}
	}
} 
function prtdepositdetail()
{    //shou yajin mingxi
  
	Template=path+"JF_DailyDetail.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet  
    temp=yjData.join("!")
    vbdata=temp.split("!")
    var yjnumber=vbdata.length
    for (i=0;i<=vbdata.length-1;i++)
    {
         str=vbdata[i].split(",")
         for (j=0;j<=str.length-1;j++)
         {
             xlsheet.cells(i+5,j+1)=str[j]
             xlsheet.Cells(i+5,j+1).Borders(9).LineStyle = 1
             xlsheet.Cells(i+5,j+1).Borders(7).LineStyle = 1
             xlsheet.Cells(i+5,j+1).Borders(10).LineStyle = 1
             xlsheet.Cells(i+5,j+1).Borders(8).LineStyle = 1
          }
     }
     /*
     var yjnum=eval(syjnum)+eval(tyjnum)
     xlsheet.cells(vbdata.length+7,1).value=t['jst22']+syjsum
     xlsheet.cells(vbdata.length+8,1).value=t['jst27']
     xlsheet.cells(vbdata.length+9,1).value=t['jst03']+":"+sxjsum.toFixed(2)
     xlsheet.cells(vbdata.length+9,3).value=sxjnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+10,1).value=t['jst04']+":"+szpsum.toFixed(2)
     xlsheet.cells(vbdata.length+10,3).value=szpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+11,1).value=t['jst05']+":"+shpsum.toFixed(2)
     xlsheet.cells(vbdata.length+11,3).value=shpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+12,1).value=t['jst25']+":"+syhksum.toFixed(2)
     xlsheet.cells(vbdata.length+12,3).value=syhknum+" "+t['jst13']    
     xlsheet.cells(vbdata.length+13,1).value=t['jst24']+":"+syklysum.toFixed(2)
     xlsheet.cells(vbdata.length+13,3).value=syklynum+" "+t['jst13']
     //tuifei
     xlsheet.cells(vbdata.length+7,4).value=t['jst23']+tyjsum
     xlsheet.cells(vbdata.length+7,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+8,4).value=t['jst27']
     xlsheet.cells(vbdata.length+8,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+9,4).value=t['jst03']+txjsum.toFixed(2)
     xlsheet.cells(vbdata.length+9,6).value=txjnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+9,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+10,4).value=t['jst04']+":"+tzpsum.toFixed(2)
     xlsheet.cells(vbdata.length+10,6).value=tzpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+10,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+11,4).value=t['jst05']+":"+thpsum.toFixed(2)
     xlsheet.cells(vbdata.length+11,6).value=thpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+11,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+12,4).value=t['jst25']+":"+tyhksum.toFixed(2)
     xlsheet.cells(vbdata.length+12,6).value=tyhknum+" "+t['jst13']    
     xlsheet.cells(vbdata.length+12,4).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+13,4).value=t['jst24']+":"+tyklysum.toFixed(2)
     xlsheet.cells(vbdata.length+13,6).value=tyklynum+" "+t['jst13']
     xlsheet.cells(vbdata.length+13,4).HorizontalAlignment=-4131
     //zuofei
     xlsheet.cells(vbdata.length+7,7).value=t['jst26']+zfyjsum
     xlsheet.cells(vbdata.length+7,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+8,7).value=t['jst27']  //zuofei
     xlsheet.cells(vbdata.length+8,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+9,7).value=t['jst03']+":"+zfxjsum.toFixed(2)
     xlsheet.cells(vbdata.length+9,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+9,9).value=zfxjnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+10,7).value=t['jst04']+":"+zfzpsum.toFixed(2)
     xlsheet.cells(vbdata.length+10,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+10,9).value=zfzpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+11,7).value=t['jst05']+":"+zfhpsum.toFixed(2)
     xlsheet.cells(vbdata.length+11,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+11,9).value=zfhpnum+" "+t['jst13']
     xlsheet.cells(vbdata.length+12,7).value=t['jst25']+":"+zfyhksum.toFixed(2)
     xlsheet.cells(vbdata.length+12,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+12,9).value=zfyhknum+" "+t['jst13']    
     xlsheet.cells(vbdata.length+13,7).value=t['jst24']+":"+zfyklysum.toFixed(2)
     xlsheet.cells(vbdata.length+13,7).HorizontalAlignment=-4131
     xlsheet.cells(vbdata.length+13,9).value=zfyklynum+" "+t['jst13']
     var tpnum=(eval(tzpnum)+eval(thpnum)).toString(10)
     xlsheet.cells(vbdata.length+14,1).value=t['jst12']+allnum+","+t['jst27']+t['11']+zfnum+","+t['jst28']+tpnum
     xlsheet.cells(vbdata.length+15,1).value=t['jst29']+t['jst30']+tzpnum+t['jst13'] //tzp
     for (i=0;i<=tzpnum-1;i++)
     {   xlsheet.cells(yjnumber+i+16,2).HorizontalAlignment=-4131
         xlsheet.cells(yjnumber+i+16,2).value=tzpData[i]
     }
     xlsheet.cells(yjnumber+tzpnum+16,1).value="   "+t['jst31']+thpnum+t['jst13']  //thp
	
     for (i=0;i<=thpnum-1;i++)
     {   xlsheet.cells(yjnumber+tzpnum+i+17,2).HorizontalAlignment=-4131
         xlsheet.cells(yjnumber+tzpnum+i+17,2).value=thpData[i]
     }
     xlsheet.cells(yjnumber+tzpnum+thpnum+17,1).value=t['jst10']+":"+gusername
     xlsheet.cells(yjnumber+tzpnum+thpnum+17,7).value=t['jst21']+curdate
     xlsheet.cells(3,2).value=curdate
     xlsheet.cells(yjnumber+tzpnum+thpnum+19,1).value=t['jst08']+":"+gusername
     xlsheet.cells(yjnumber+tzpnum+thpnum+19,4).value=t['jst09']+":"
     xlsheet.cells(yjnumber+tzpnum+thpnum+19,7).value=t['jst20']
     
     //xlsheet.cells(3,8).value=t['jst18']+":"+"   "+t['jst19']
     */
     if (parent.frames['UDHCJFDepositSearch'])
     { 
        var stdate=parent.frames['UDHCJFDepositSearch'].document.getElementById("stdate").value
   	     var enddate=parent.frames['UDHCJFDepositSearch'].document.getElementById("enddate").value
     }
     if (parent.frames['UDHCJFSearch'])
     {   var stdate=parent.frames['UDHCJFSearch'].document.getElementById("stdate").value
   	     var enddate=parent.frames['UDHCJFSearch'].document.getElementById("enddate").value
     }
     var year,mon,day,str
     str=stdate.split("/")
     day=str[0],mon=str[1], year=str[2]
     stdate=year+"-"+mon+"-"+day
     str=enddate.split("/")
     day=str[0],mon=str[1], year=str[2]
     enddate=year+"-"+mon+"-"+day
	 //if (tjdate=="")
	 //{  
		// }else{
	 xlsheet.cells(3,2).value=stdate+" --- "+enddate
	 //xlsheet.cells(3,2).value=parent.frames['UDHCJFSearch'].tjdate //}
     xlApp.Visible=true
	 xlsheet.PrintPreview();
     //xlsheet.printout
     xlBook.Close (savechanges=false);
	 xlApp.Quit();
	 xlApp=null;
  	 xlsheet=null
}
function PrintInvDetail()
{	Template=path+"JF_PrintInvDetail.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	fpstr=""
	  
	 getcurdate()
	 getprintdate()
	
	temp=fpData.join("!")
	
	vbdata=temp.split("!")
	for (i=0;i<=vbdata.length-1;i++)
	{   
	    str=vbdata[i].split(",")
	    var rcptno=str[9]
	    fpstr=fpstr+"^"+rcptno
	    for (j=0;j<=str.length-1;j++)
	    {    xlsheet.cells(i+4,j+1)=str[j]    	      
	     }
	}
    
    var hrow=vbdata.length-1
	var lrow=str.length-1
	AddGrid(xlsheet,0,0,hrow,lrow,4,1) 
	/*
	xlsheet.cells(vbdata.length+5,1).value=t['17']+patfee
	xlsheet.cells(vbdata.length+7,6).value=t['jst17']+allnum+t['jst13']+" "+t['16']+zfnum+t['jst13']
	xlsheet.cells(vbdata.length+9,1).value=t['jst08']
    xlsheet.cells(vbdata.length+9,6).value=t['jst09']+curdate
    xlsheet.cells(vbdata.length+11,1).value=t['jst10']+gusername
    xlsheet.cells(vbdata.length+11,6).value=t['jst11']
    xlsheet.cells(vbdata.length+13,1).value=t['jst25']
    xlsheet.cells(vbdata.length+5,1).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+7,1).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+9,1).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+11,1).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+5,6).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+7,6).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+9,6).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+11,6).HorizontalAlignment=-4131
 	xlsheet.cells(vbdata.length+13,1).HorizontalAlignment=-4131
	*/
	//if (tjdate=="")
	 //{  xlsheet.cells(2,32).value=stdate+" --- "+endate
		// }else{
	 //xlsheet.cells(2,3).value=parent.frames['UDHCJFSearch'].tjdate   //}
	//fpno
	if (parent.frames['UDHCJFSearch'])
     {   var stdate=parent.frames['UDHCJFSearch'].document.getElementById("stdate").value
   	     var enddate=parent.frames['UDHCJFSearch'].document.getElementById("enddate").value
     }
	xlsheet.cells(2,3).value=stdate+" --- "+endate
	var str,flag=0,fprcpt=""
	str=fpstr.split("^")
	for (j=1;j<str.length;j++)
	{
		var rcptno1
	    rcptno1=parseInt(str[j],10) 
      	rcptno1=rcptno1+1 
   	    
   	    var nextno
   	    nextno=str[j+1] 
   	    nextno=parseInt(nextno,10) 
        //
	    if (flag=="0")
	    {
		   var startno=str[j]
		   var endno=str[j]
		   flag="1"
	    }
	   if ((rcptno1!=nextno))
	   {   endno=str[j]
	       if (fprcpt=="")
	       {   fprcpt=startno+"--"+endno  }
	       else
	       {   fprcpt=fprcpt+","+startno+"---"+endno}
	       
	       flag="0"
	   }
	}	
	//xlsheet.cells(vbdata.length+7,1).value=t['jst24']+fprcpt
	//xlsheet.printout
	xlApp.Visible=true;
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function printshdepositdetail()
{   //chu yuan shou hui yajin mingxi 
    var xjsum=0,zpsum=0,hpsum=0,grzhsum=0,yhksum=0,allnum=0,yklysum=0
    var totalsum=0
    Template=path+"JF_DailyDetail.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
    getcurdate()
    getprintdate()
    var paymodestr,row=0
	paymodestr=t['jstpaymode'].split("_")
    
	var Objtbl=parent.frames['UDHCJFInvRpt'].document.getElementById('tUDHCJFInvRpt');
	var Rows=Objtbl.rows.length;
	var allnum=0,prtnum=0
	var num=new Array()
	for (i=1;i<=Rows-2;i++)
	{   
	    SelRowObj=parent.frames['UDHCJFInvRpt'].document.getElementById('Trowidz'+i);
	    var fprowid=SelRowObj.innerText;
	    var yjstr=document.getElementById('getyjstr');
	    if (yjstr) {var encmeth=yjstr.value} else {var encmeth=''};	
	    var shyjstr=cspRunServerMethod(encmeth,fprowid)
	    shyjstr1=shyjstr.split("^")
	    num[i]=shyjstr1.length
	    var lastnum=num[i]
	    if (i!=1)
	    {
		    allnum=allnum+num[i-1]-1
	    }
	    var prtstatus=shyjstr1[0]
	    if (prtstatus=="S") 
	    {   prtnum=prtnum-num[i]+1
	         }
	    if ((prtstatus=="N")||(prtstatus=="I"))
	    {    prtnum=prtnum+num[i]-1  
	          }
	    //row=0
	    for (j=1;j<num[i];j++)
	    {  
	        var prtrowid=shyjstr1[j]
	    	//if (prtrowid!="")
	    	//{   row=row+1     }
	    	if (prtrowid=="")
	    	{   continue ;}
		    var prtdeposit=document.getElementById('getcytyj');
	        if (prtdeposit) {var encmeth=prtdeposit.value} else {var encmeth=''};	
		    var prtstr=cspRunServerMethod(encmeth,prtrowid,prtstatus)
		//if (prtstr=="")  {row=row-1}
		if (prtstr!="")   
		{  row=row+1    
		   
		  prtstr=prtstr.split("^")
		     for (k=0;k<=prtstr.length-1;k++)
		    {	xlsheet.cells(row+4,k+1)=prtstr[k]
                //xlsheet.Cells(row+4,k+1).Borders(9).LineStyle = 1
	           // xlsheet.Cells(row+4,k+1).Borders(7).LineStyle = 1
	           // xlsheet.Cells(row+4,k+1).Borders(10).LineStyle = 1
	           // xlsheet.Cells(row+4,k+1).Borders(8).LineStyle = 1			
		      }
		    if (prtstr[9]!=t['16'])
			{    totalsum=eval(totalsum)+eval(prtstr[4])
			     if (prtstr[5]==paymodestr[0])
			    {  xjsum=eval(xjsum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[1])
			    {  zpsum=eval(zpsum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[2])
			    {  yklysum=eval(yklysum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[3])
			    {  hpsum=eval(hpsum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[4])
			    {  yklysum=eval(yklysum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[5])
			    {  yhksum=eval(yhksum)+eval(prtstr[4])}
			    if (prtstr[5]==paymodestr[6])
			    {  yklysum=eval(yklysum)+eval(prtstr[4])}
			}
		}//
	    }
	}
	 xlsheet.cells(allnum+lastnum+2,2).value=t['17']
	 xlsheet.cells(allnum+lastnum+2,5).value=eval(totalsum).toFixed(2).toString(10)
	 AddGrid(xlsheet,4,1,allnum+lastnum+2,10,4,1)
	 xlsheet.cells(allnum+lastnum+5,2).value=t['jst02']+(eval(xjsum)+eval(zpsum)+eval(hpsum)+eval(yhksum)+eval(yklysum)).toFixed(2).toString(2)
     xlsheet.cells(allnum+lastnum+6,2).value=t['jst03']+":"+eval(xjsum).toFixed(2).toString(10)
     xlsheet.cells(allnum+lastnum+6,5).value=t['jst04']+":"+eval(zpsum).toFixed(2).toString(10)
     xlsheet.cells(allnum+lastnum+7,2).value=t['jst05']+":"+eval(hpsum).toFixed(2).toString(10)
     xlsheet.cells(allnum+lastnum+7,5).value=t['jst07']+":"+eval(yhksum).toFixed(2).toString(10)
     xlsheet.cells(allnum+lastnum+8,2).value=t['jst14']+":"+eval(yklysum).toFixed(2).toString(10)
     xlsheet.cells(allnum+lastnum+10,2).value=t['jst08']
     xlsheet.cells(allnum+lastnum+10,7).value=t['jst09']+curdate
     xlsheet.cells(allnum+lastnum+12,2).value=t['jst10']+gusername
     xlsheet.cells(allnum+lastnum+12,7).value=t['jst11']
     xlsheet.cells(allnum+lastnum+14,2).value=t['jst25']
     
     xlsheet.cells(allnum+lastnum+5,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+6,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+6,5).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+7,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+7,5).HorizontalAlignment=-4131
	 xlsheet.cells(allnum+lastnum+8,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+10,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+10,7).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+12,2).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+12,7).HorizontalAlignment=-4131
     xlsheet.cells(allnum+lastnum+14,2).HorizontalAlignment=-4131
     xlsheet.cells(2,1)=t['jst15']
    // if (tjdate=="")
	 //{  xlsheet.cells(3,3).value=stdate+" --- "+endate
		// }else{
	 xlsheet.cells(3,2).value=parent.frames['UDHCJFSearch'].tjdate    //}
     xlApp.Visible=true
	 xlsheet.PrintPreview();
     //xlsheet.printout
     xlBook.Close (savechanges=false);
	 xlApp.Quit();
	 xlApp=null;
  	 xlsheet=null
}
function PrintHCDetail()
{   var totalsum1,totalsum2,totalsum3
    totalsum1=0,totalsum2=0,totalsum3=0
    if (parent.frames['UDHCJFInvSearch'])
    {  var flag=parent.frames['UDHCJFInvSearch'].document.getElementById("flag").value  }
    else
    {  var flag=parent.frames['UDHCJFSearch'].document.getElementById("flag").value    }
	
    getcurdate()
    getprintdate()
    if (flag=="")
    {  xlsheet.Cells(1,1).value=t['jst26']
    }
    var getchnum=document.getElementById('getchnum');
	if (getchnum) {var encmeth=getchnum.value} else {var encmeth=''};	
	var chnum=cspRunServerMethod(encmeth,job)
	
	if (chnum==""){return;}
	Template=path+"JF_CHDetail.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
	for (i=0;i<chnum;i++)
	{   
	var getchdetail=document.getElementById('getchdetail');
	    if (getchdetail) {var encmeth=getchdetail.value} else {var encmeth=''};	
	    var chdetail=cspRunServerMethod(encmeth,job,i+1)
	    if (chdetail!="")   
		{
	    chdetail1=chdetail.split("^")
		for (j=0;j<=chdetail1.length-1;j++)
		{	xlsheet.cells(4+i,j+1).value=chdetail1[j]            
         }
         totalsum1=eval(totalsum1)+eval(chdetail1[5])
         totalsum2=eval(totalsum2)+eval(chdetail1[6])
         totalsum3=eval(totalsum3)+eval(chdetail1[7])
		}
	}
	xlsheet.cells(2,2).value=parent.frames['UDHCJFSearch'].tjdate   
	xlsheet.cells(i+4,1).value=t['17']
	xlsheet.cells(i+4,6).value=eval(totalsum1).toFixed(2).toString(10)
	xlsheet.cells(i+4,7).value=eval(totalsum2).toFixed(2).toString(10)
	xlsheet.cells(i+4,8).value=eval(totalsum3).toFixed(2).toString(10)
	AddGrid(xlsheet,4,1,i+4,9,4,1)
	//xlsheet.printout
	xlApp.Visible=true;
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function PrintFlDetail()
{   //an feilei feiyong 
	var jstfp,fp
	var subdata
    var subdata1 = new Array();
    var subdata2 = new Array();
    var subdata3 = new Array();
    var qita=0.00
    
	Template=path+"JF_FlDetail.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
    getcurdate()
    getprintdate()
    
    jstfp=t['HXEYfp']
    fp=jstfp.split("_")
    
    var str=document.getElementById('getflfee');
	if (str) {var encmeth=str.value} else {var encmeth=''};	
	var subdata=cspRunServerMethod(encmeth,job)
	
	subdata1=subdata.split("!");	
	for (i=1;i<subdata1.length;i++){
		var tmpstrs=subdata1[i];
		subdata2[i-1]=tmpstrs.split("^");		 				
	}
	
	for (i=0;i<subdata2.length;i++){  
 	      
 	      switch (subdata2[i][0]){
		        case fp[0]:   //xiyao
		          xlsheet.cells(5,3).value=subdata2[i][1]
			        break;
			    case fp[1]:   //zhongchengyao
			        xlsheet.cells(6,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[2]:   //zhongcaoyao
			        xlsheet.cells(7,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[3]:   //chuangweifei
			        xlsheet.cells(20,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[4]:   //zhiliaofei
			        xlsheet.cells(11,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[5]:   //fangshefangliao
			        xlsheet.cells(10,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[6]:   //fangshejiancha
			        xlsheet.cells(9,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[7]:   //jianchafei
			       xlsheet.cells(8,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[8]:   //shoushufei
			        xlsheet.cells(13,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[9]:   //mazuifei
			        xlsheet.cells(14,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[10]:   //huayanfei
			        xlsheet.cells(15,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[11]:   //cailiaofei
			        xlsheet.cells(12,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[12]:   //shuxuefei
			        xlsheet.cells(16,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[13]:   //yangqifei
			        xlsheet.cells(17,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[14]:   //yingerfei
			        xlsheet.cells(18,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[15]:   //texuchuangweifei
			        xlsheet.cells(21,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[15]:   //huishifei
			        xlsheet.cells(22,3).value=subdata2[i][1]			    	
			    	break;
			    case fp[16]:   //qitafei
			        if (subdata2[i][1]!="0.00")
			        {
			        qita=eval(qita)+eval(subdata2[i][1])}			        
			    	break;
			    default:
			        if (subdata2[i][1]!="0.00")
			        {
			        qita=eval(qita)+eval(subdata2[i][1])			       
			        }			        
			        break;
			    }
		    }
        qita=qita.toFixed(2)
        xlsheet.cells(19,3).value=qita   
	
	xlsheet.cells(23,2)=t['17']
	xlsheet.cells(23,3)=patfee
	
  
	xlsheet.cells(3,2)=t['15']+parent.frames['UDHCJFSearch'].tjdate
    xlsheet.cells(25,2).value=t['jst02']+" "+cyshdeposit
    xlsheet.cells(25,3).value=t['jst21']+" "+stje
    xlsheet.cells(26,2).value=t['jst08']+" "+gusername
    xlsheet.cells(26,3).value=t['jst09']+" "+curdate
    
	xlsheet.cells(25,2).HorizontalAlignment=-4131
    xlsheet.cells(25,3).HorizontalAlignment=-4131
	xlsheet.cells(26,2).HorizontalAlignment=-4131
    xlsheet.cells(26,3).HorizontalAlignment=-4131
    
	xlApp.Visible=true
    xlsheet.PrintPreview();
    //xlsheet.printout
    xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
  	xlsheet=null
}    