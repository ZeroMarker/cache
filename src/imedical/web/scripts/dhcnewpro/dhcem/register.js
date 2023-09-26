/// Creator: huaxiaoying
/// CreateDate: 2016-08-15
var regno="";
$(document).ready(function() {
	
	initParams();
	
	initICheck();
	
	initCombobox();
	
	initDateBox();
	
	initDatagrid()
	
	initMethod();
		
});

function initICheck(){
	
	/*$HUI.iCheck('#isRegCheck',{
  		onChecked:function(e,value){
	  		alert("OK");
	  	}
	});	*/
}

///初始化参数
function initParams(){
	DateFormat = "";
	runClassMethod("web.DHCEMRegister","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
}

///绑定方法
function initMethod(){
	$('#regno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur()
        }
    });	
    
    //查找按钮导出按钮 保存按钮
    $("#searchBtn").on('click',function(){	
		search();
	})

	///导出
	$("#exportBtn").on('click',function(){	
		expExcel();
	})
	
}

///初始化combobox
function initCombobox(){
	$(".prev").parent().css("visibility","hidden"); //隐藏
	//号别
	$HUI.combobox("#loc",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=getEmeNumInfo&hosp="+hosp,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	//来诊方式
	$HUI.combobox("#from",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=ListPatAdmWay" ,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	//症状
	$HUI.combobox("#symptom",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=jsonEmPatSymptomLev",
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
		
	$HUI.combobox("#level",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=GetNurLevel",
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	$HUI.combobox("#screening",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=GetScreeningInfo",
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	$HUI.combobox("#screening",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=GetScreeningInfo",
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	
	$HUI.combobox("#pastHistory",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=GetEmPatChkHis",
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	$HUI.combobox("#swichLoc",{
		valueField:'id',
		textField:'text',
		data:[{'id':'1','text':'急诊科'},
			  {'id':'2','text':'中西医结合一科'},
			  {'id':'3','text':'中西医结合二科'}
			  ],
		onSelect:function(option){
	       
	    }	
	})	
	
	
	//号别科室
	$HUI.combobox("#levCareLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+hosp,
		valueField:'value',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
}

///初始化事件控件
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0-SEECHKDATE));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function initDatagrid(){
	var columns = [[
        /*
        {
	        title: '选择',
            checkbox: true
         },
         */
        {
            field: 'num',
            title: '序号'
        }, {
            field: 'admDate',
            title: '创建日期'
        }, {
            field: 'admTime',
            title: '创建时间'
        },{
            field: 'SeeDocDate',
            title: '就诊日期'
        }, {
            field: 'SeeDocTime',
            title: '就诊时间'
        }, {
            field: 'WaitTime',
            title: '等候时间'
        },{
            field: 'currregno',
            title: '登记号'
        }, {
            field: 'name',
            align: 'center',
            title: '姓名'
        }, {
            field: 'sex',
            align: 'center',
            title: '性别'
        }, {
            field: 'age',
            align: 'center',
            title: '年龄'  
        }, {
            field: 'symptom',
            align: 'center',
            title: '症状'
        }, { //2016-09-21 congyue
            field: 'EmAware',
            align: 'center',
            title: '神志' //意识状态
        }, {
            field: 'PCSTemp',  //体温T 2016-09-03 congyue
            align: 'center',
            title: 'T(℃)'
        }, {
            field: 'PCSHeart',
            align: 'center',
            title: 'HR(次/分)'
        }, {
            field: 'PCSPCSPulse',
            align: 'center',
            title: 'P(次/分)'
        }, {
            field: 'PCSBP', //BP 2016-09-03 congyue
            align: 'center',
            title: 'BP(mmHg)'        
        },{
            field: 'PCSR', //BP 2016-09-03 congyue
            align: 'center',
            title: 'R(次/分)'        
        },{
            field: 'EmPcsSoP2', //BP 2016-09-03 congyue
            align: 'center',
            title: 'SPO2(%)'        
        },{
            field: 'EmPcsGLU', //BP 2016-09-03 congyue
            align: 'center',
            title: 'Glu(mmol/l)'        
        },{
            field: 'SignHis', //BP 2016-09-03 congyue
            align: 'center',
            title: '体征记录',
            formatter:function(value,row,index){
				return '<a href="#" title="历史"  onclick="openSignHis('+row.PCLRowID+')">历史</a>';
			}        
        },{
            field: 'tel',
            align: 'center',
            title: '电话'
        }, {
            field: 'PCLCareLoc',
            align: 'center',
            title: '分诊科室'
        },{
            field: 'curmarkno',
            align: 'center',
            title: '号别'
        }, {
            field: 'PCLAdmWay',
            align: 'center',
            title: '来诊方式'
        }, {
            field: 'IsGreenAdm',
            align: 'center',
            title: '绿色通道'
        },{
            field: 'PCLPatAskFlag',
            align: 'center',
            title: '假条',
            formatter:function(value,row,index){
				if (value=='Y'){return '是';} 
				else {return '否';}
			}//hxy 2018-10-22
        }, {
            field: 'SickHistory',
            align: 'center',
            title: '既往史'
        },
        {
            field: 'VeerLocDesc',
            align: 'center',
            title: '转诊科室'
        },
         {
            field: 'NurseLevel',
            align: 'center',
            title: '护士分级',
            formatter:setCellLabel  //hxy 2020-02-20
        },
         {
            field: 'PCLNurUser',
            align: 'center',
            title: '分诊护士'
        }]]
        
  
	$HUI.datagrid('#registerTable',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'分诊查询', //hxy 2018-10-09 st
		toolbar:'#toolbar',
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			Params:getParams()
		},
		onDblClickRow:function(index,row){
			linkToCsp(row);
		},
		onLoadSuccess:function(data){

		}
    })
}


function openSignHis(EmPCLvID){
	var lnk = "dhcem.patchecksignhis.csp?EmPCLvID="+EmPCLvID;
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: '分诊生命体征历史查询',
		closed: true,
		onClose:function(){}
	});
}

///  效验时间栏录入数据合法性 add 2016-09-23
function CheckDHCCTime(id){
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		dhccBox.alert("请录入正确的时间格式！例如:18:23,请录入1823","register-three");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		//dhccBox.alert("我的message","classname");
		dhccBox.alert("小时数不能大于23！","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("分钟数不能大于59！","register-one");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}

/// 获取焦点后时间栏设置 add 2016-09-23
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
///清空科室下拉
function clearLoc(){
	$('#Loc').val("");	
	$("#Loc").attr("title","");
	$("#Loc").empty();
}	
///查找按钮
function search(){
	
	$HUI.datagrid('#registerTable').load({
		Params:getParams()
	})
	return ;

}
//function save(){
//	alert(3);
//}

///补零方法
function RegNoBlur()
{
	var i;
    var regno=$('#regno').val();
    var oldLen=regno.length;
    if (oldLen==8) return;
	if (regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#regno").val(regno);
}

///获取Params
function getParams(){
	var Note=""
    $("input[type=checkbox][name=Note]").each(function(){
		if($(this).is(':checked')){
			Note=this.value;
		}
	})
	
	var registerFlag=""
	
	if($("#isRegCheck").is(":checked")){
		registerFlag=1;
	}
	
	if($("#noRegCheck").is(":checked")){
		registerFlag=2;
	}
	var levCareLoc = $g($HUI.combobox('#levCareLoc').getValue())
	var Params;
	Params = $HUI.datebox("#startDate").getValue()+"^"+$HUI.datebox("#endDate").getValue()+"^"+$('#regno').val()
	Params=Params+"^"+$g($HUI.combobox('#loc').getValue())+"^"+$g($HUI.combobox('#from').getValue())+"^"+$HUI.timespinner('#startTime').getValue();
	Params = Params+"^"+$HUI.timespinner('#endTime').getValue()
	Params=Params+"^"+Note+"^"+$g($HUI.combobox('#symptom').getValue())+"^"+$g($HUI.combobox('#level').getValue())
	Params = Params+"^"+$g($HUI.combobox('#pastHistory').getValue())+"^"+$g($HUI.combobox('#screening').getValue())+"^"+hosp
	Params = Params+"^"+registerFlag+"^"+levCareLoc
	return Params;
}

//导出 2016-09-21 congyue
function expExcelOld()
{
	///获取导出数据 cy
	var strjLen=0; 
 	var strjData="";	
	runClassMethod("web.DHCEMRegister","GetRegisterNew",{},
	function(data){ 
		strjData=data;
		strjLen=data.length;
	},'json',false)
	
	var TemplatePath="";
	var xlsApp,xlsSheet,xlsBook;
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function(jsonString){
		TemplatePath = jsonString;
	},'',false)
	
	xlsApp = new ActiveXObject("Excel.Application");
	xlsBook = xlsApp.Workbooks.Add();
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;
	xlsApp.Range(xlsSheet.Cells(1,1),xlsSheet.Cells(1,24)).MergeCells = true;
	xlsSheet.cells(1,1).Font.Bold = true;
	xlsSheet.cells(1,1).Font.Size =24;
	xlsSheet.cells(1,1).HorizontalAlignment = -4108;
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':locId},function(jsonString){
		xlsSheet.cells(1,1) = jsonString;     //QQA  2016-10-16   
	},'text',false)
	
	xlsSheet.cells(2,1)="序号";  
	xlsSheet.cells(2,2)="创建日期";
   	xlsSheet.cells(2,3)="创建时间";
    xlsSheet.cells(2,4)="登记号";
    xlsSheet.cells(2,5)="姓名";
    xlsSheet.cells(2,6)="性别";
    xlsSheet.cells(2,7)="年龄";
    xlsSheet.cells(2,8)="症状";
    xlsSheet.cells(2,9)="神志";
    xlsSheet.cells(2,10)="T(℃)";
    xlsSheet.cells(2,11)="HR(次/分)";
    xlsSheet.cells(2,12)="P(次/分)";
    xlsSheet.cells(2,13)="BP(mmHg)";
    xlsSheet.cells(2,14)="R(次/分)";
    xlsSheet.cells(2,15)="SPO2(%)";
    xlsSheet.cells(2,16)="Glu(mmol/l) ";
    xlsSheet.cells(2,17)="电话";
    xlsSheet.cells(2,18)="分级";
    xlsSheet.cells(2,19)="号别";
    xlsSheet.cells(2,20)="来诊方式";
    xlsSheet.cells(2,21)="假条";
    xlsSheet.cells(2,22)="转诊科室";
    xlsSheet.cells(2,23)="既往史";
    xlsSheet.cells(2,24)="分诊科室";
	//xlsSheet.cells(1,1) = "东华人民医院";   //QQA  2016-10-16
    for (i=1;i<=strjLen;i++)
    { 
	    xlsSheet.cells(i+2,1)=strjData[i-1].num;
		xlsSheet.cells(i+2,2)=strjData[i-1].admDate;
	    xlsSheet.cells(i+2,3)=strjData[i-1].admTime;
	    xlsSheet.cells(i+2,4)="'"+strjData[i-1].currregno;
	    xlsSheet.cells(i+2,5)=strjData[i-1].name;
	    xlsSheet.cells(i+2,6)=strjData[i-1].sex;
	    xlsSheet.cells(i+2,7)=strjData[i-1].age;
	    xlsSheet.cells(i+2,8)=strjData[i-1].symptom; //症状=症状字典库录入+其他填写栏内容 cy
	    xlsSheet.cells(i+2,9)=strjData[i-1].EmAware; //意识状态 cy
	    xlsSheet.cells(i+2,10)=strjData[i-1].PCSTemp; //体温T cy
	    xlsSheet.cells(i+2,11)=strjData[i-1].PCSHeart;
	    xlsSheet.cells(i+2,12)=strjData[i-1].PCSPCSPulse;
	    xlsSheet.cells(i+2,13)=strjData[i-1].PCSBP; //BP cy
	    xlsSheet.cells(i+2,14)=strjData[i-1].PCSR
	    xlsSheet.cells(i+2,15)=strjData[i-1].EmPcsSoP2
	    xlsSheet.cells(i+2,16)=strjData[i-1].EmPcsGLU
	    xlsSheet.cells(i+2,17)="'"+strjData[i-1].tel;
	    xlsSheet.cells(i+2,18)=setCell(strjData[i-1].PCLNurseLevel); //考虑到有推荐分级，如果护士录入分级，则取护士分级，否则取推荐分级 cy //hxy 2020-02-20
	    xlsSheet.cells(i+2,19)=strjData[i-1].curmarkno;	   
	    xlsSheet.cells(i+2,20)=strjData[i-1].PCLAdmWay;
	    xlsSheet.cells(i+2,21)=strjData[i-1].PCLPatAskFlag;
	    xlsSheet.cells(i+2,22)=strjData[i-1].VeerLocDesc;
	    xlsSheet.cells(i+2,23)=strjData[i-1].SickHistory;
	    xlsSheet.cells(i+2,24)=strjData[i-1].PCLCareLoc;
	    
 	 }
 	 gridlist(xlsSheet,1,strjLen+2,1,24)
     xlsSheet.Columns.AutoFit; 
   
     
    succflag=xlsBook.SaveAs("分诊查询.xls");
	xlApp.Visible=true;
	xlsBook=null; 
    xlsSheet=null; 
	return succflag;
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

function $g(){	
	if (arguments[0]== null || arguments[0]== undefined) return "" 
	return arguments[0];
}

function linkToCsp(row){
	var lnk = "dhcem.emerpatientinfom.csp?EpisodeID="+ row.EpisodeID +"&EmPCLvID="+row.PCLRowID+"&PatientID="+row.patientID;
	var openCss = 'width='+(window.screen.availWidth-100)+',height='+(window.screen.availHeight-160)+ ', top=100, left=50, location=no,toolbar=no, menubar=no, scrollbars=yes, resizable=no,status=no'
	window.open(lnk,'newwindow',openCss) 
}

//hxy 2020-02-20
function setCellLabel(value,row,index){
	if(value=="1级"){value="Ⅰ级";}
	if(value=="2级"){value="Ⅱ级";}
	if(value=="3级"){value="Ⅲ级";}
	if(value=="4级"){value="Ⅳa级";}
	if(value=="5级"){value="Ⅳb级";}
	return value;
}
//hxy 2020-02-20
function setCell(value){
	if(value=="1"){value="Ⅰ";}
	if(value=="2"){value="Ⅱ";}
	if(value=="3"){value="Ⅲ";}
	if(value=="4"){value="Ⅳa";}
	if(value=="5"){value="Ⅳb";}
	return value;
}

//导出 2020-04-08 hxy
function expExcel()
{
	///获取导出数据 
	var strjLen=0; 
 	var strjData="";	
	runClassMethod("web.DHCEMRegister","GetRegisterNew",{},
	function(data){ 
		strjData=data;
		strjLen=data.length;
	},'json',false)
		
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var xlSheet = xlBook.ActiveSheet;";
	
	Str=Str+"xlSheet.PageSetup.LeftMargin=0;"+
	"xlSheet.PageSetup.RightMargin=0;"+
	"xlSheet.Application.Visible = true;"+
	"xlApp.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,24)).MergeCells = true;"+
	"xlSheet.cells(1,1).Font.Bold = true;"+
	"xlSheet.cells(1,1).Font.Size =24;"+
	"xlSheet.cells(1,1).HorizontalAlignment = -4108;";
	
	runClassMethod("web.DHCEMRegister","gethHospitalName",{'locId':locId},function(jsonString){
		Str=Str+"xlSheet.cells(1,1).value='"+jsonString+"';";    //QQA  2016-10-16   
	},'text',false)
	
	Str=Str+"xlSheet.cells(2,1).value='序号';";
	Str=Str+"xlSheet.cells(2,2).value='创建日期';";
	Str=Str+"xlSheet.cells(2,3).value='创建时间';";
	Str=Str+"xlSheet.cells(2,4).value='登记号';";
	Str=Str+"xlSheet.cells(2,5).value='姓名';";
	Str=Str+"xlSheet.cells(2,6).value='性别';";
	Str=Str+"xlSheet.cells(2,7).value='年龄';";
	Str=Str+"xlSheet.cells(2,8).value='症状';";
	Str=Str+"xlSheet.cells(2,9).value='神志';";
	Str=Str+"xlSheet.cells(2,10).value='T(℃)';";
	Str=Str+"xlSheet.cells(2,11).value='HR(次/分)';";
	Str=Str+"xlSheet.cells(2,12).value='P(次/分)';";
	Str=Str+"xlSheet.cells(2,13).value='BP(mmHg)';";
	Str=Str+"xlSheet.cells(2,14).value='R(次/分)';";
	Str=Str+"xlSheet.cells(2,15).value='SPO2(%)';";
	Str=Str+"xlSheet.cells(2,16).value='Glu(mmol/l)';";
	Str=Str+"xlSheet.cells(2,17).value='电话';";
	Str=Str+"xlSheet.cells(2,18).value='分级';";
	Str=Str+"xlSheet.cells(2,19).value='号别';";
	Str=Str+"xlSheet.cells(2,20).value='来诊方式';";
	Str=Str+"xlSheet.cells(2,21).value='假条';";
	Str=Str+"xlSheet.cells(2,22).value='转诊科室';";
	Str=Str+"xlSheet.cells(2,23).value='既往史';";
	Str=Str+"xlSheet.cells(2,24).value='分诊科室';";
	
    for (i=1;i<=strjLen;i++)
    { 
        //alert(strjData[i-1].num+"num")
	    Str=Str+"xlSheet.cells("+(i+2)+",1).value='"+strjData[i-1].num+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",2).value='"+strjData[i-1].admDate+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",3).value='"+strjData[i-1].admTime+"';";
	    Str=Str+"xlSheet.Columns(4).NumberFormatLocal='@';";
	    Str=Str+"xlSheet.cells("+(i+2)+",4).value='"+strjData[i-1].currregno+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",5).value='"+strjData[i-1].name+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",6).value='"+strjData[i-1].sex+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",7).value='"+strjData[i-1].age+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",8).value='"+strjData[i-1].symptom+"';"; //症状=症状字典库录入+其他填写栏内容
	    Str=Str+"xlSheet.cells("+(i+2)+",9).value='"+strjData[i-1].EmAware+"';"; //意识状态
	    Str=Str+"xlSheet.cells("+(i+2)+",10).value='"+strjData[i-1].PCSTemp+"';"; //体温T
	    Str=Str+"xlSheet.cells("+(i+2)+",11).value='"+strjData[i-1].PCSHeart+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",12).value='"+strjData[i-1].PCSPCSPulse+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",13).value='"+strjData[i-1].PCSBP+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",14).value='"+strjData[i-1].PCSR+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",15).value='"+strjData[i-1].EmPcsSoP2+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",16).value='"+strjData[i-1].EmPcsGLU+"';";
	    Str=Str+"xlSheet.Columns(17).NumberFormatLocal='@';";
	    Str=Str+"xlSheet.cells("+(i+2)+",17).value='"+strjData[i-1].tel+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",18).value='"+strjData[i-1].PCLNurseLevel+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",19).value='"+strjData[i-1].curmarkno+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",20).value='"+strjData[i-1].PCLAdmWay+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",21).value='"+strjData[i-1].PCLPatAskFlag+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",22).value='"+strjData[i-1].VeerLocDesc+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",23).value='"+strjData[i-1].SickHistory+"';";
	    Str=Str+"xlSheet.cells("+(i+2)+",24).value='"+strjData[i-1].PCLCareLoc+"';";  
 	 }
 	 
 	 var row1=1,row2=strjLen+2,c1=1,c2=24;
	 Str=Str+"xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	 "xlSheet.Range(xlSheet.Cells("+row1+","+c1+"),xlSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;";
 	 
     Str=Str+"xlSheet.Columns.AutoFit;"; 
	 Str=Str+"xlBook.SaveAs('分诊查询.xls');"+
	 "xlApp.Visible=true;"+
	 "xlApp=null;"+
	 "xlBook=null;"+
	 "xlSheet=null;"+
     "return 1;}());";
     //以上为拼接Excel打印代码为字符串
     CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	 var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	 return;
}
