//INSUAuditReport.js
var iSeldRow=0,Job
function BodyLoadHandler() {
	Guser=session['LOGON.USERID'];
	GuserName=session['LOGON.USERNAME'];
	GROUPID=session['LOGON.GROUPID'];
	HOSPID=session['LOGON.HOSPID'];
	var UserName=document.getElementById("UserName").value ;
	var objtbl=document.getElementById("tINSUAuditReport") ;
    var now= new Date()
    var hour= now.getHours();
    
    var obj=document.getElementById("Export");  //2012-04-05 统计汇总导出
	if (obj){obj.onclick=Export_Click;}
	init_Layout();
	$HUI.combobox(('#UserName'),{
		defaultFilter:'4',
		valueField: 'TUsrRowid',
		textField: 'TUsrName',
		url:$URL,
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}
		,onBeforeLoad: function(param) {
			param.ClassName = 'DHCBILLConfig.DHCBILLOthConfig';
			param.QueryName= 'FindGroupUser';
			param.Grp = GROUPID;
			param.Usr = "";
			param.HospId = HOSPID;
			param.ResultSetType = 'array';
			return true;
		}		
	})


}
function InitDetails(){
	var StartDate=getValueById("StartDate") ;
	var EndDate=getValueById("EndDate") ;	
	var UserName=getValueById("UserName") ;
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=INSUAuditReport&StartDate="+StartDate+"&EndDate="+EndDate+"&UserName="+UserName+"&HOSPID="+HOSPID+"&GROUPID="+GROUPID;
	parent.frames['INSUAuditReport'].location.href=lnk;
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=INSUAuditRepDetails&UserDr="+""+"&StartDate="+""+"&EndDate="+""+"&Job="+"";
	parent.frames['INSUAuditRepDetails'].location.href=lnk;
	}

function SelectRowHandler(index,rowData)	{
	//var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tINSUAuditReport');
	//var rowObj=getRow(eSrc);
	var selectrow=index+1 //rowObj.rowIndex;
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		AdmRowid="";
		}
	else
	{
		iSeldRow=selectrow;
		var SelRowObj
		var obj
		SelRowObj=document.getElementById('tINSUAuditReport') //document.getElementById('TUserDrz'+selectrow);
		if (SelRowObj){UserRowid=rowData.TUserDr }//SelRowObj.value;}
		else{UserRowid="";}
		//SelRowObj=document.getElementById('Jobz'+selectrow);
		if (SelRowObj){Job=rowData.Job }//SelRowObj.value;}SelRowObj.value;}
		//DHCWeb_HISUIalert(Job)
		var StartDate=getValueById("StartDate") ;
		var EndDate=getValueById("EndDate") ;
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=INSUAuditRepDetails&UserDr="+UserRowid+"&StartDate="+StartDate+"&EndDate="+EndDate+"&Job="+Job;
	parent.frames['INSUAuditRepDetails'].location.href=lnk;
}


function Export_Click() //增加打印功能 Lou 2011-10-22
{
	try{
	if(UserRowid=="")
	{
		DHCWeb_HISUIalert("请先选择一个收费员!")
		return;
	}

	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
    var Template
    var path=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","");
    Template=path+"INSU_AuditFeeTJ.xls"
    //DHCWeb_HISUIalert(Template)
	/*
	try{
		xlApp = new ActiveXObject("Excel.Application");
	 }catch(e){
	     DHCWeb_HISUIalert(e.message);
	     return
	}finally{
	
	} 
	*/
    xlApp = new ActiveXObject("Excel.Application");
    
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet ; 
	var str=""
	
	var UserDate=tkMakeServerCall("web.INSUAudUserReport","GetUserDate",UserRowid,Job);
	if (UserDate==""){
		DHCWeb_HISUIalert("没有操作员审核汇总信息");
		return;
		}
	
	UserDate=UserDate.split("^")
	/*
	SelRowObj=document.getElementById('UserDesc'+iSeldRow);  //操作员姓名
	if (SelRowObj){str="  审核人:"+SelRowObj.innerText;
	var SHR=SelRowObj.innerText;
	DHCWeb_HISUIalert(SHR)
	}
	SelRowObj=document.getElementById('Num'+iSeldRow);  //人次
	if (SelRowObj){str=str+"  人次:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TotalAmount'+iSeldRow); //审核总金额
	if (SelRowObj){str=str+"  审核总金额:"+SelRowObj.innerText;}
	xlsheet.Cells(3,1)=str
	*/
	//xlsheet.Cells(3,1)="审核人："+UserDate[0]+" 人次："+UserDate[1]+" 审核总金额："+UserDate[2]
	xlsheet.Cells(3,2)=UserDate[0]
	xlsheet.Cells(3,4)=UserDate[1]
	xlsheet.Cells(3,6)=UserDate[2]
	xlsheet.Cells(3,10)=UserDate[3]
	Obj=document.getElementById('StartDate'); //查询开始日期
	if (Obj){xlsheet.Cells(4,2)=Obj.value.split("/")[2]+"-"+Obj.value.split("/")[1]+"-"+Obj.value.split("/")[0];}
	Obj=document.getElementById('EndDate');  //查询结束日期
	if (Obj){xlsheet.Cells(4,6)=Obj.value.split("/")[2]+"-"+Obj.value.split("/")[1]+"-"+Obj.value.split("/")[0];}
	
	
	var DetailsNum=tkMakeServerCall("web.INSUAudUserReport","GetDateNum",UserRowid,Job);   //add hwq 2012-01 12
	

	for (i=1;i<=DetailsNum;i++)
	{

		var PayData=tkMakeServerCall("web.INSUAudUserReport","GetData",UserRowid,i,Job);   //

		var PayData=PayData.split("^")
		    DataLength=PayData.length;

		xlsheet.cells(5,1)="病人ID";
		xlsheet.cells(5,2)="姓名";
		xlsheet.cells(5,3)="科室";
		xlsheet.cells(5,4)="诊断";
		xlsheet.cells(5,5)="入院日期";
		xlsheet.cells(5,6)="出院日期";
		xlsheet.cells(5,7)="总费用";
		xlsheet.cells(5,8)="病案号";
		xlsheet.cells(5,9)="住院处审核完成时间";
		xlsheet.cells(5,10)="医保办审核完成时间";
		xlsheet.cells(5,11)="医保审核-离院时间";
		xlsheet.cells(5,12)="医保-住院处时间";
		xlsheet.cells(5,13)="住院处-离院时间";

		xlsheet.cells(5+i,1)=PayData[0];
		xlsheet.cells(5+i,2)=PayData[1];
		xlsheet.cells(5+i,3)=PayData[2];
		xlsheet.cells(5+i,4)=PayData[3];
		xlsheet.cells(5+i,5)=PayData[4];
		xlsheet.cells(5+i,6)=PayData[5];
		xlsheet.cells(5+i,7)=PayData[6];
		xlsheet.cells(5+i,8)=PayData[7];
		xlsheet.cells(5+i,9)=PayData[8];
		xlsheet.cells(5+i,10)=PayData[9];
		xlsheet.cells(5+i,11)=PayData[10];
		xlsheet.cells(5+i,12)=PayData[11];
		xlsheet.cells(5+i,13)=PayData[12];

		/*for (k=1;k<=7;k++)
		{
			xlsheet.Cells(6+i,k).Borders(9).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(7).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(10).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(8).LineStyle = 1;
		}
		*/
		//}
	}
	//var TObj=parent.frames["INSUAuditDetailsIP"];
	//var objtbl=TObj.document.getElementById('tINSUAuditDetailsIP');
	//var SelRowObj;
	/*
	for(i=1;i<objtbl.rows.length;i++) 
	{ 
	
		xlsheet.cells(6+i,1)=objtbl.rows(i).cells(2).innerText;
		xlsheet.cells(6+i,2)=objtbl.rows(i).cells(3).innerText;
		xlsheet.cells(6+i,3)=objtbl.rows(i).cells(4).innerText;
		xlsheet.cells(6+i,4)=objtbl.rows(i).cells(5).innerText;
		xlsheet.cells(6+i,5)=objtbl.rows(i).cells(6).innerText;
		xlsheet.cells(6+i,6)=objtbl.rows(i).cells(12).innerText;
		xlsheet.cells(6+i,7)=objtbl.rows(i).cells(13).innerText;
	
		xlsheet.cells(6+i,1)=objtbl.rows(i).cells(1).innerText;
		xlsheet.cells(6+i,2)=objtbl.rows(i).cells(2).innerText;
		xlsheet.cells(6+i,3)=objtbl.rows(i).cells(3).innerText;
		xlsheet.cells(6+i,4)=objtbl.rows(i).cells(4).innerText;
		xlsheet.cells(6+i,5)=objtbl.rows(i).cells(5).innerText;
		xlsheet.cells(6+i,6)=objtbl.rows(i).cells(11).innerText;
		xlsheet.cells(6+i,7)=objtbl.rows(i).cells(13).innerText;
		for (j=1;j<=7;j++)
		{
			xlsheet.Cells(6+i,j).Borders(9).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(7).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(10).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(8).LineStyle = 1;
		}
	}
	*/
	xlApp.Visible=true;
	//xlsheet.PrintPreview();
	xlsheet.SaveAs("D:\\"+UserDate[0]+"医保审核统计.xls");    //add hwq 2012-01-12	    
	xlBook.Close(savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	DHCWeb_HISUIalert("导出完成,导出到"+"D:\\"+UserDate[0]+"医保审核统计.xls");
	}catch(e){
	     DHCWeb_HISUIalert(e.message);
	     return
	}finally{
	//DHCWeb_HISUIalert("导出完成");
	} 
}
function init_Layout(){
	$('.datagrid-sort-icon').text('')
	$('td.i-tableborder>table').css("border-spacing","0px 8px");
	$('body').css("padding-bottom","0px");
	$('.first-col').parent().parent().parent().css('margin-top','1px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top','1px');
	
}
    document.body.onload = BodyLoadHandler;