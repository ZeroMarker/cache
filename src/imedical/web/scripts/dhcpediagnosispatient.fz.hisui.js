//名称 dhcpediagnosispatient.fz.hisui.js
//功能 健康证管理
//创建 
//创建人 yupeng

var init = function(){
	
	$("#RegNo").focus();
	/// 病人信息列表  卡片样式
	function setCellLabel(value, rowData, rowIndex){
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
		 +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
		 +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>ID:'+ rowData.PAPMINo +'</span></h3>'+'<h3 style="float:right;background-color:transparent;"><span>'+ rowData.AdmDate
		 +'</span></h3><br>'
		 ;
		
		var classstyle="color: #18bc9c";
		if(rowData.VIPLevel!=""){
			if(rowData.VIPLevel==3) {classstyle="color: #f9bf3b"};
			if(rowData.VIPLevel==1) {classstyle="color: #3c78d8"};
			if(rowData.VIPLevel==2) {classstyle="color: #f22613"};
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.VIPDesc+'</span></h4>';
		}
		htmlstr = htmlstr +'</div>';
		return htmlstr;
	}
	
	
	
	var VIPObj = $HUI.combobox("#VIP",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
	})
		
	$("#Query").click(function(){
  			Query();
		});
	
	$("#BPrint").click(function(){
  			BPrint();
		});
		
		
	$("#BSave").click(function(){
  			BSave();
		});
	$("#BCancel").click(function(){
  			BCancel();
		});
	
	$("#RegNo").change(function(){
  			RegNoOnChange();
		});
		
	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        });
	
	var CanDiagnosisListObj = $HUI.datagrid("#CanDiagnosisList",{
		url:$URL,
		showHeader:false,
		pagination:true,
		singleSelect:true,
		pageSize:20,
		showRefresh:false,
		displayMsg:"",
		showPageList:false,
		fit:true,
		queryParams:{
			ClassName:"web.DHCPE.ResultNew",
			QueryName:"FindDiagnosisPatInfo",
			RegNo:"",
			HospID:session['LOGON.HOSPID']

		},
		columns:[[
			{field:'PatLabel',title:'',width:259,formatter:setCellLabel},
		    {field:'PaadmID',hidden:true},
		    {field:'PAPMINo',title:'登记号',width:50,hidden:true},
		    {field:'AdmDate',title:'体检日期',width:50,hidden:true},
		    {field:'Name',title:'姓名',width:50,hidden:true},
			{field:'Age',title:'年龄',width:50,hidden:true},
			{field:'Sex',title:'性别',width:50,hidden:true},
			{field:'VIPLevel',title:'VIP',width:50,hidden:true},
			{field:'VIPDesc',title:'VIP等级',width:50,hidden:true}
		]],
		onClickRow:function(rowIndex, rowData){
			
			
			setValueById("VIP",rowData.VIPLevel)
			setValueById("PAADM",rowData.PaadmID)
	        $('#patName').text(rowData.Name);
	        $('#sexName').text(rowData.Sex);
		    $('#Age').text(rowData.Age);
		    $('#PatNo').text(rowData.PAPMINo);
		    $('#PEDate').text(rowData.AdmDate);
		    $('#VIPLevel').text(rowData.VIPDesc);
		    $('#PatNoName').text("登记号：");
		    if (rowData.Sex == '男') {
				$('#sex').removeClass('woman').addClass('man');
			} else {
				$('#sex').removeClass('man').addClass('woman');
			}
			
			$("#CardManager").datagrid("load",{ClassName:"web.DHCPE.CardManager",QueryName:"FindCardManager",EpisodeID:rowData.PaadmID}); 
			
			var Str=tkMakeServerCall("web.DHCPE.CardManager","GetGSEx",rowData.PaadmID);
			
			var GSEx=Str.split("^")[0];
			var Remark=Str.split("^")[1];			
			$("#Conclusion").combobox('reload');
			$("#Suggestions").val("");

		
			
			var HadAudit=tkMakeServerCall("web.DHCPE.CardManager","GetHadAudit",rowData.PaadmID);
			
			if (HadAudit=="N")
			{
				obj =document.getElementById("BCancel");
		 		if(obj){obj.style.display="none";}
				obj =document.getElementById("BSave");
		 		if(obj){obj.style.display="";}
			
			}
			else
			{
				obj =document.getElementById("BSave");
		 		if(obj){obj.style.display="none";}
				obj =document.getElementById("BCancel");
		 		if(obj){obj.style.display="";}
		 	}
		    $("#Conclusion").combobox("setValue",GSEx);
			  $("#Suggestions").val(Remark);
	    }
	});

	
	$HUI.datagrid("#CardManager",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.CardManager",
			QueryName:"FindCardManager",
			EpisodeID:""
				
		},
		columns:[[	
		   
			
			{field:'Name',title:'项目名称',width:150},	
		    {field:'EngName',title:'英文名',width:100},
			{field:'Result',title:'结果',width:450},
			{field:'Range',title:'参考范围',width:100},
			{field:'TSInfo',title:'提示',width:100},
			{field:'Unit',title:'单位',width:100}
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			
		}
			
	});
	
	
	var ConclusionObj = $HUI.combobox("#Conclusion",{
		url:$URL+"?ClassName=web.DHCPE.CardManager&QueryName=OutConclusion&ResultSetType=array",
		valueField:'id',
		textField:'Desc',
		onBeforeLoad:function(param){
			
			var VIP=getValueById("VIP");
			param.VIPLevel = VIP;
		}
		
		})
	
	
};

 



function RegNoOnChange()
{
	var RegNo=getValueById("RegNo")
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
	}
  var HospID=session['LOGON.HOSPID']
	$("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:$("#RegNo").val(),HospID:HospID}); 
	
}


function Query()
{
	var HospID=session['LOGON.HOSPID']
	var BDate=getValueById("BDate")
	var EDate=getValueById("EDate")
	var VIP=getValueById("VIP")
	var RegNo=getValueById("RegNo")
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}

	$("#CanDiagnosisList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindDiagnosisPatInfo",RegNo:RegNo,BDate:BDate,EDate:EDate,VIP:VIP,HospID:HospID}); 
	
}

function BSave()
{
	 var ret=SaveApp();
	 if (ret=="0"){
		 obj =document.getElementById("BSave");
		 if(obj){obj.style.display="none";}
		 obj =document.getElementById("BCancel");
		 if(obj){obj.style.display="";}
		 
	 }else{
		 //$.messager.alert("提示",ret,"info");
	 }
	
	
}


function BCancel()
{
	 var EpisodeID="";
	 EpisodeID=getValueById("PAADM");
	 
	 var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosis","AuditStationS",EpisodeID,"Cancel","0","N");
	 
	
	 if (ret=="0"){
		 
		 obj =document.getElementById("BCancel");
		 if(obj){obj.style.display="none";}
		 obj =document.getElementById("BSave");
		 if(obj){obj.style.display="";}
		 
	 }else{
		  if(ret=="ReMainHadAudit"){$.messager.alert("提示","复检已提交!","info");}
		 if(ret=="NoSS"){$.messager.alert("提示","还未小结!","info");}
		 if(ret=="ReportStatusErr"){
			 $.messager.alert("提示","报告状态不是打印或者审核状态,请取消已完成等操作!","info");}


	 }
	
}

function SaveApp()
{
	 var EpisodeID="",Conclusion="",Suggestions="";
	
	 EpisodeID=getValueById("PAADM");
	 Conclusion=getValueById("Conclusion");
	 
	  if(Conclusion==""){
		  $.messager.alert("提示","结论不能为空!","info");
		 return 1;
		 }
	 
	 
	Suggestions=getValueById("Suggestions");

	
	var ret=tkMakeServerCall("web.DHCPE.CardManager","Save",EpisodeID,Conclusion,Suggestions);
	
	return ret;
 }

 //打印回执单xml
 function PrintHZDXML()
 { 
 
    var Char_2=String.fromCharCode(2);
	var EpisodeID="",HOSPID="";
	var TxtInfo="";
	var EpisodeID=getValueById("PAADM");
	
	/*
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
	if (dtformat=="YMD"){
			var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
		}
	if (dtformat=="DMY"){
			var CurDate=mydate.getDate()+"/"+CurMonth+"/"+mydate.getFullYear(); 
		}
	*/	
		
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	//var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate();
	var cha=((Date.parse(CurMonth+'/'+mydate.getDate()+'/'+mydate.getFullYear()) - Date.parse("12/31/1840"))/86400000);
	var CurDate = Math.abs(Math.floor(cha));
	var CurDate = tkMakeServerCall("websys.Conversions","DateLogicalToHtml",CurDate);
 
	
	var HOSPID=session['LOGON.HOSPID'];
	var HosName=""
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID)
	var BaseInfo=tkMakeServerCall("web.DHCPE.CardManager","GetBaseInfo",EpisodeID,HOSPID);
	var BaseArr=BaseInfo.split("^");
	
	var TxtInfo="Name"+Char_2+BaseArr[0]+"^";
	var TxtInfo=TxtInfo+"Sex"+Char_2+BaseArr[1]+"^";
	 var TxtInfo=TxtInfo+"Age"+Char_2+BaseArr[2]+"^";
	 var TxtInfo=TxtInfo+"BarRegNo"+Char_2+BaseArr[5]+"^";
	  var TxtInfo=TxtInfo+"RegNo"+Char_2+BaseArr[5]+"^";
	 var TxtInfo=TxtInfo+"OrdSet"+Char_2+BaseArr[7]+"^";
	 var TxtInfo=TxtInfo+"AdmDate"+Char_2+BaseArr[6]+"^";
	 var TxtInfo=TxtInfo+"Tel"+Char_2+BaseArr[3]+"^";
	 var TxtInfo=TxtInfo+"HPNo"+Char_2+BaseArr[4]+"^";
	 var TxtInfo=TxtInfo+"HospitalName"+Char_2+HosName+"^";
	 var TxtInfo=TxtInfo+"HZDate"+Char_2+CurDate+"^";
	 //var TxtInfo=TxtInfo+"VIP"+Char_2+BaseArr[9]+"^";
	 var TxtInfo=TxtInfo+"VIP"+Char_2+BaseArr[9].split(" ")[0]+"^";
	var ResultInfo=tkMakeServerCall("web.DHCPE.CardManager","GetResultInfo",EpisodeID);
	if (ResultInfo!=""){
		var ResultArr=ResultInfo.split("^");
		 var TxtInfo=TxtInfo+"TSInfo"+Char_2+ResultArr[0]+"^";
		 var TxtInfo=TxtInfo+"Result"+Char_2+ResultArr[1]+"^";
		 var TxtInfo=TxtInfo+"ODUnit"+Char_2+ResultArr[2]+"^";
		 var TxtInfo=TxtInfo+"Range"+Char_2+ResultArr[3]; 
	}else{
		var TxtInfo=TxtInfo+"TSInfo"+Char_2+""+"^";
		 var TxtInfo=TxtInfo+"Result"+Char_2+""+"^";
		 var TxtInfo=TxtInfo+"ODUnit"+Char_2+""+"^";
		 var TxtInfo=TxtInfo+"Range"+Char_2+"";
		}
	
	//alert("TxtInfo:"+TxtInfo)
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEJKZHZ");
    //var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,"");
	DHC_PrintByLodop(getLodop(),TxtInfo,"","","");

 } 

 //打印健康证xml
function BPrintXML()
{
	var EpisodeID="";
	EpisodeID=getValueById("PAADM");
	var ret=tkMakeServerCall("web.DHCPE.CardManager","GetReportInfoXML",EpisodeID);
	var TxtInfo=ret;
    //alert("TxtInfo:"+TxtInfo)
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEJKZ");
    //var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,"");
	DHC_PrintByLodop(getLodop(),TxtInfo,"","","");
}

function BPrint()
{
	var EpisodeID="";
	EpisodeID=getValueById("PAADM");
	var ret=tkMakeServerCall("web.DHCPE.CardManager","GetReportInfo",EpisodeID);
	
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("提示",Arr[1],"info");
		return false;
	}else if(Arr[0]=="-2"){
		//PrintHZD();
		PrintHZDXML();
		return false;
	}
	BPrintXML();
	return false;

	var Templatefilepath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath")+'DHCPEJKZ.xls';
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	//PatID_"^"_Name_"^"_Sex_"^"_Dob_"^"_RegNo_"^"_CardNo
	xlsheet.cells(3,2).Value=Arr[1];
	xlsheet.cells(4,2).Value=Arr[2];
	xlsheet.cells(4,4).Value=Arr[3];
	xlsheet.cells(8,5).Value=Arr[5];
	xlsheet.cells(8,1).Value="*"+Arr[4]+"*";
	try{
		var msoShaoeRectangle=1;
		var ShapeRange=xlsheet.Shapes.AddShape(msoShaoeRectangle, 190, 20, 60, 75);
		ShapeRange.Line.Visible = false;
		var imgStr=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPhotoPath",Arr[4])
		
		ShapeRange.Fill.UserPicture(imgStr); 
	}catch(e){
		ShapeRange.Visible=false;
	}
	xlsheet.printout(1,10,1,false,"Datacard Printer")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	CollectGarbage();
	
	
}


function PrintHZD()
 {
	var EpisodeID="",HOSPID="";
	EpisodeID=getValueById("PAADM");
	HOSPID=session['LOGON.HOSPID'];
	var BaseInfo=tkMakeServerCall("web.DHCPE.CardManager","GetBaseInfo",EpisodeID)
	
	var ResultInfo=tkMakeServerCall("web.DHCPE.CardManager","GetResultInfo",EpisodeID)
	
	var Templatefilepath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath")+'DHCPEJKZHZ.xls';
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var BaseArr=BaseInfo.split("^");
	var HosName=""
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID)
    
	if(HosName.indexOf("[")>-1){var HosName=HosName.split("[")[0];}
        xlsheet.cells(1,3).Value=HosName+"体检回执单";

	xlsheet.cells(1,8).Value=BaseArr[5];
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value+BaseArr[0];
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value+BaseArr[1];
	xlsheet.cells(2,5).Value=xlsheet.cells(2,5).Value+BaseArr[2];
	xlsheet.cells(2,7).Value=xlsheet.cells(2,7).Value+BaseArr[9];
	xlsheet.cells(2,10).Value=xlsheet.cells(2,10).Value+BaseArr[3];
	xlsheet.cells(3,1).Value=xlsheet.cells(3,1).Value+BaseArr[4];
	xlsheet.cells(3,5).Value=xlsheet.cells(3,5).Value+BaseArr[6];
	xlsheet.cells(3,8).Value=xlsheet.cells(3,8).Value+BaseArr[7];
	xlsheet.cells(4,1).Value=xlsheet.cells(4,1).Value+BaseArr[8];
	xlsheet.cells(4,7).Value=xlsheet.cells(4,7).Value+BaseArr[10];
	//xlsheet.cells(4,9).Value=xlsheet.cells(4,9).Value+Remark;
	//xlsheet.cells(12,1).Value="";
	//xlsheet.cells(5,1).Value=xlsheet.cells(5,1).Value+BaseArr[15];
	xlsheet.cells(7,9).Value=BaseArr[11];
	var obj=document.getElementById("NoPrintAmount");
	if (obj&&obj.checked) { xlsheet.cells(7,9).Value="" }
	xlsheet.cells(9,11).Value=BaseArr[14];
	if(BaseArr[14]==""){xlsheet.cells(8,11).Value="";}
	xlsheet.Range(xlsheet.cells(7,1),xlsheet.cells(7,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(10,1),xlsheet.cells(10,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(11,1),xlsheet.cells(11,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(12,1),xlsheet.cells(12,11)).BorderS(4).LineStyle=7;
	var DietDesc=BaseArr[12];
	var PhotoDesc=BaseArr[13];
	if (DietDesc!=""){
		DietDesc=DietDesc+"  "+PhotoDesc;
	}else{
		DietDesc=PhotoDesc;
	}    
	xlsheet.cells(1,1).Value=DietDesc;
	if (ResultInfo!=""){
		var ResultArr=ResultInfo.split("^");
		xlsheet.cells(7,4).Value=ResultArr[0];
		xlsheet.cells(7,6).Value=ResultArr[1];
		xlsheet.cells(7,8).Value=ResultArr[2];
		xlsheet.cells(7,10).Value=ResultArr[3];
	}
	try{
		var msoShaoeRectangle=1;
		var ShapeRange=xlsheet.Shapes.AddShape(msoShaoeRectangle, 10, 10, 60, 75);
		ShapeRange.Line.Visible = false;
		var imgStr=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPhotoPath",BaseArr[5].split("*")[1])
		
		ShapeRange.Fill.UserPicture(imgStr); 
	}catch(e){
		ShapeRange.Visible=false;
	}
	xlsheet.printout(1,10,1,false)
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	CollectGarbage();
	
 }


$(init);