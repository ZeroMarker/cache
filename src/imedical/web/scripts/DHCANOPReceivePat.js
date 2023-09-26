//window.self.moveTo(-5,-5);
//window.self.resizeTo(screen.availWidth+8,screen.availHeight+8);
var oproomdes="",opordno="",patName="",sex="",age="",medCareNo="",regNo=""
var locdes="",bedCode="",opdate="",jzstat="",Status="",patWard="",inArea=""
var oproomdr="",opaId="",EpisodeID="",loc="",opordcon="",rowNum=""
var first=0,flag=0;
var ctlocId=session['LOGON.CTLOCID'];
var patInfoMessage="",showMessage="";
var stdate="",enddate="",medCareNo="",regno="",InAreaFlag="",UnInAreaFlag=""
var lastregon="",lastmedCareNo=""

function BodyLoadFunction()
{
	var myDate=new Date();
	var myYear=myDate.getFullYear();
	var myMonth=myDate.getMonth()+1;
	var myDay=myDate.getDate();
	var obj=document.getElementById('stdate');
	//if(obj.value=="") obj.value=myDay+"/"+myMonth+"/"+myYear;
	if(obj.value=="") obj.value="08/10/2011";
	var obj=document.getElementById('enddate');
	//if(obj.value=="") obj.value=myDay+"/"+myMonth+"/"+myYear;
	if(obj.value=="") obj.value="08/10/2011";
	var obj=document.getElementById('BtnSch');
	if(obj) obj.onclick=BtnSch_Click;
	var obj=document.getElementById('medCareNo');
	if(obj) obj.onkeydown=MedCareNoOnkeydown;
	var obj=document.getElementById('regno');
	if(obj) obj.onkeydown=RegnoOnkeydown;
	var obj=document.getElementById('chbInArea');
	if(obj) obj.onclick=ChbInArea_Click;
	var obj=document.getElementById('chbUnInArea');
	if(obj)
	{
		obj.onclick=ChbUnInArea_Click;
		obj.checked=true;
	}
	document.getElementById('regno').focus();
	GetSchValue();
	var GetOperInfo=document.getElementById('GetOperInfo').value;
		cspRunServerMethod(GetOperInfo,stdate,enddate,medCareNo+"^"+regno+"^"+InAreaFlag+"^"+UnInAreaFlag+"^"+ctlocId);
}
function BtnSch_Click()
{
	var mainTable=document.getElementById('tbPatInfoList');
	CleartTbl(mainTable);  //删除最后一空行之前所有行
	GetSchValue();
	var GetOperInfo=document.getElementById('GetOperInfo').value;
		cspRunServerMethod(GetOperInfo,stdate,enddate,medCareNo+"^"+regno+"^"+InAreaFlag+"^"+UnInAreaFlag+"^"+ctlocId);	
	//alert(lastmedCareNo+"/"+lastregon+"/"+flag)
	if((lastmedCareNo=="")&&(lastregon==""))
	{
		mainTable.deleteRow(1);  //删除第一行
	}
	if((lastmedCareNo!="")||(lastregon!=""))
	{
		mainTable.deleteRow(1);
	}
}
function ReSchPatInfo()
{
	document.getElementById('medCareNo').value="";
	document.getElementById('regno').value="";
	var mainTable=document.getElementById('tbPatInfoList');
	CleartTbl(mainTable);  //删除最后一空行之前所有行
	GetSchValue();
	var GetOperInfo=document.getElementById('GetOperInfo').value;
		cspRunServerMethod(GetOperInfo,stdate,enddate,medCareNo+"^"+regno+"^"+InAreaFlag+"^"+UnInAreaFlag+"^"+ctlocId);	
	if((lastmedCareNo=="")&&(lastregon==""))
	{
		mainTable.deleteRow(1);  //删除第一行
	}
	if((lastmedCareNo!="")||(lastregon!=""))
	{
		mainTable.deleteRow(1);
	}
}
function MedCareNoOnkeydown()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		lastmedCareNo=document.getElementById('medCareNo').value;
		BtnSch_Click();
		if(patInfoMessage!="")
		{
			showMessage="";
			var opaId=patInfoMessage.split("^")[15];
			//oproomdes_"^"_opordno_"^"_patName_"^"_sex_"^"_age_"^"_medCareNo_"^"_regNo_"^"_locdes_"^"_bedCode_"^"_opdate_"^"_jzstat_"^"_Status_"^"_patWard_"^"_inArea_"^"_oproomdr_"^"_opaId_"^"_EpisodeID_"^"_loc_"^"_opordcon
			showMessage=showMessage+"手术间:"+patInfoMessage.split("^")[0]+"   台次:"+patInfoMessage.split("^")[1]+"   病人姓名:"+patInfoMessage.split("^")[2]+"   性别:"+patInfoMessage.split("^")[3]+"   年龄:"+patInfoMessage.split("^")[4]+"\n"
			showMessage=showMessage+"住院号:"+patInfoMessage.split("^")[5]+"   登记号:"+patInfoMessage.split("^")[6]+"   类型:"+patInfoMessage.split("^")[10]+"   状态:"+patInfoMessage.split("^")[11]+"\n"
			showMessage=showMessage+"科室:"+patInfoMessage.split("^")[7]+"   床号:"+patInfoMessage.split("^")[8]+"   病区:"+patInfoMessage.split("^")[12]+"\n";
			showMessage=showMessage+"手术名称:"+patInfoMessage.split("^")[19]+"   主刀医生:"+patInfoMessage.split("^")[20];
			//showMessage=showMessage+"手术日期:"+patInfoMessage.split("^")[9]+"	入等候区时间:"+patInfoMessage.split("^")[13]+"	手术号:"+patInfoMessage.split("^")[15]
			//alert(showMessage);
			var retMessage=window.confirm(showMessage);
			if (retMessage==false) 
			{
				ReSchPatInfo();
				return
			}
			var SetInAreaDateTime=document.getElementById('SetInAreaDateTime').value;
			var ret=cspRunServerMethod(SetInAreaDateTime,opaId);
		}
		else
		{
			alert("不是查询日的手术病人!");
		}
		ReSchPatInfo();
	}
}
function RegnoOnkeydown()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		lastregon=document.getElementById('regno').value;
		BtnSch_Click();
		if(patInfoMessage!="")
		{
			showMessage="";
			var opaId=patInfoMessage.split("^")[15];
			showMessage=showMessage+"手术间:"+patInfoMessage.split("^")[0]+"   台次:"+patInfoMessage.split("^")[1]+"   病人姓名:"+patInfoMessage.split("^")[2]+"   性别:"+patInfoMessage.split("^")[3]+"   年龄:"+patInfoMessage.split("^")[4]+"\n"
			showMessage=showMessage+"住院号:"+patInfoMessage.split("^")[5]+"   登记号:"+patInfoMessage.split("^")[6]+"   类型:"+patInfoMessage.split("^")[10]+"   状态:"+patInfoMessage.split("^")[11]+"\n"
			showMessage=showMessage+"科室:"+patInfoMessage.split("^")[7]+"   床号:"+patInfoMessage.split("^")[8]+"   病区:"+patInfoMessage.split("^")[12]+"\n";
			showMessage=showMessage+"手术名称:"+patInfoMessage.split("^")[19]+"   主刀医生:"+patInfoMessage.split("^")[20];
			//showMessage=showMessage+"手术日期:"+patInfoMessage.split("^")[9]+"	入等候区时间:"+patInfoMessage.split("^")[13]+"	手术号:"+patInfoMessage.split("^")[15]
			//alert(showMessage);
			var retMessage=window.confirm(showMessage);
			if (retMessage==false) 
			{
				ReSchPatInfo();
				return
			}
			var SetInAreaDateTime=document.getElementById('SetInAreaDateTime').value;
			var ret=cspRunServerMethod(SetInAreaDateTime,opaId);
		}
		else
		{
			alert("不是查询日的手术病人!");
		}
		ReSchPatInfo();
	}
}
function GetSchValue()
{
	stdate=document.getElementById('stdate').value;
	enddate=document.getElementById('enddate').value;
	medCareNo=document.getElementById('medCareNo').value;
	regno=document.getElementById('regno').value;
	var obj=document.getElementById('chbInArea');
	if(obj.checked==true) InAreaFlag=1;
	else InAreaFlag=0;
	var obj=document.getElementById('chbUnInArea');
	if(obj.checked==true) UnInAreaFlag=1;
	else UnInAreaFlag=0;
}
function CleartTbl(objtbl)
{
	var Row=objtbl.rows.length-1;
	for (var i=1;i<Row;i++)
	{
		objtbl.deleteRow(i);
		i=i-1;
		Row=Row-1;
		flag=flag+1;
	}
}
function ChbInArea_Click()
{
	var obj=document.getElementById('chbUnInArea');
	obj.checked=false;
}
function ChbUnInArea_Click()
{
	var obj=document.getElementById('chbInArea');
	obj.checked=false;
}
function GetOperInfo(str)
{
	patInfoMessage=str;
	//oproomdes,opordno,patName,sex,age,medCareNo,regNo,locdes,bedCode,opdate,jzstat,Status,patWard,inArea,oproomdr,opaId,EpisodeID,loc,opordcon
	if(str!=""){
  	StrArry=str.split('^');
	oproomdes=StrArry[0];
	opordno=StrArry[1];
	patName=StrArry[2];
	sex=StrArry[3];
	age=StrArry[4];
	medCareNo=StrArry[5];
	regNo=StrArry[6];
	locdes=StrArry[7];
	bedCode=StrArry[8];
	opdate=StrArry[9];
	jzstat=StrArry[10];
	Status=StrArry[11];
	patWard=StrArry[12];
	inArea=StrArry[13];
	oproomdr=StrArry[14];
	opaId=StrArry[15];
	EpisodeID=StrArry[16];
	loc=StrArry[17];
	opordcon=StrArry[18];
	opdes=StrArry[19];
	opd=StrArry[20];
	diag=StrArry[21];
	
	rowNum=StrArry[22];
	
	TablePatInfo=document.getElementById('tbPatInfoList');
  	if(first!=0)
  	{
		AddRow(TablePatInfo);
	}
		Row=TablePatInfo.rows.length-1;

	var Id='row'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[0].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[0].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[0].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+rowNum+"</label></div>";
	var Id='oproom'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[1].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[1].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[1].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+oproomdes+"</label></div>";
	var Id='opordno'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[2].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[2].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[2].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+opordno+"</label></div>";
	
	var Id='opordcon'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[3].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[3].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[3].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+opordcon+"</label></div>";
	
	var Id='patname'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[4].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[4].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[4].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+patName+"</label></div>";
	var Id='sex'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[5].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[5].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[5].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+sex+"</label></div>";
	var Id='age'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[6].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[6].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[6].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+age+"</label></div>";
	
	var Id='opdes'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[7].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[7].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[7].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+opdes+"</label></div>";
	var Id='opd'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[8].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[8].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[8].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+opd+"</label></div>";
	var Id='diag'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[9].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[9].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[9].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+diag+"</label></div>";

	var Id='TMedCareNo'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[10].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[10].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[10].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+medCareNo+"</label></div>";
	var Id='regno'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[11].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[11].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[11].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+regno+"</label></div>";
	var Id='loc'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[12].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[12].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[12].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+locdes+"</label></div>";
	var Id='bedCode'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[13].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[13].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[13].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+bedCode+"</label></div>";
	var Id='opdatestr'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[14].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[14].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[14].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+opdate+"</label></div>";
	var Id='jzstat'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[15].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[15].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[15].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+jzstat+"</label></div>";
	var Id='status'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[16].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[16].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[16].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+Status+"</label></div>";
	var Id='patWard'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[17].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[17].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		TablePatInfo.rows[Row].cells[17].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+patWard+"</label></div>";
	var Id='inArea'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[18].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[18].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
	if(inArea!="") stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #EE4000;\"";
		//stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000093;\"";
		//stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #aa0000;\"";
		TablePatInfo.rows[Row].cells[18].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >"+inArea+"</label></div>";

    	  first=1;
    	  UpdateFlag=0;
	}
	else
	{
		addRow();
	}
}
function addRow()
{
	TablePatInfo=document.getElementById('tbPatInfoList');
	AddRow(TablePatInfo);
	Row=TablePatInfo.rows.length-1;

	var Id='row'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[0].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[0].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[0].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='oproom'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[1].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[1].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[1].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='opordno'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[2].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[2].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[2].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	
	var Id='opordcon'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[3].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[3].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[3].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	
	var Id='patname'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[4].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[4].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[4].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='sex'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[5].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[5].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[5].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='age'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[6].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[6].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[6].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	
	var Id='opdes'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[7].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[7].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[7].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='opd'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[8].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[8].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[8].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='diag'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[9].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[9].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[9].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";

	var Id='TMedCareNo'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[10].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[10].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[10].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='regno'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[11].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[11].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[11].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='loc'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[12].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[12].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[12].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='bedCode'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[13].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[13].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[13].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='opdatestr'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[14].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[14].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[14].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='jzstat'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[15].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[15].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[15].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='status'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[16].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[16].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[16].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='patWard'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[17].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[17].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[17].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
	var Id='inArea'+'z'+Row;
	var objwidth=TablePatInfo.rows[Row-1].cells[18].width-30;
	var objheight=TablePatInfo.rows[Row-1].cells[18].style.height;
	var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:12pt;color: #000;\"";
		TablePatInfo.rows[Row].cells[18].innerHTML="<label id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr+" >&nbsp;</label></div>";
}
function stdate_lookupSelect(dateval) 
{
	var obj=document.getElementById('stdate');
	obj.value=dateval;
	websys_nextfocusElement(obj);
}
function stdate_lookuphandler(e) 
{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) 
	{
		var obj=document.getElementById('stdate');
		//if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=stdate&TLUDESC='+t['stdate']+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function stdate_changehandler(e) 
{
	var eSrc=document.getElementById('stdate');
	if (!IsValidDate(eSrc)) 
	{
		eSrc.className='clsInvalid';
		websys_setfocus('stdate');
		websys_cancel();
	}
	 else 
	 {
		if (eSrc.readOnly) 
		{
			eSrc.className='clsReadOnly'
		}
		else 
		{
			eSrc.className=''
		}
		window.setTimeout("ForceChange('stdate');",1);
	}
}
function enddate_lookupSelect(dateval) 
{
	var obj=document.getElementById('enddate');
	obj.value=dateval;
	websys_nextfocusElement(obj);
}
function enddate_lookuphandler(e) 
{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) 
	{
		var obj=document.getElementById('enddate');
		//if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=enddate&TLUDESC='+t['enddate']+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function enddate_changehandler(e) 
{
	var eSrc=document.getElementById('enddate');
	if (!IsValidDate(eSrc)) 
	{
		eSrc.className='clsInvalid';
		websys_setfocus('enddate');
		websys_cancel();
	} 
	else 
	{
		if (eSrc.readOnly) 
		{
			eSrc.className='clsReadOnly'
		} 
		else 
		{
			eSrc.className=''
		}
		window.setTimeout("ForceChange('enddate`');",1);
	}
}
