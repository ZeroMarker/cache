/// Creator: huaxiaoying
/// CreateDate: 2016-08-15
var Regno="";
$(function(){ 
    //$("#Regno").val("0000000001"); //要删除
	//回车事件
     $('#Regno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur()
        }
    });
});
$(document).ready(function() {
	$(".prev").parent().css("visibility","hidden"); //隐藏
	$(".prev").css("visibility","hidden");
	//$(".prev").next().css("visibility","hidden");
	$(".next").css("visibility","hidden");
	//$(".prev").parent().parent().next().css("width","200px");
	//急诊科室
	$('#Loc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=FindMarkNo"   
	});
	//来诊方式
	$('#from').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=ListPatAdmWay"   
	});
	
    $('#registerTb').dhccTable({
	    height:window.parent.tabHeight-80,
	    //sidePagination:'side',
	    pageSize:15,
	    pageList:[50,100],
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNew',
        columns: [{
            checkbox: false
        },{
            field: 'num',
            title: '序号'
        }, {
            field: 'admDate',
            title: '日期'
        }, {
            field: 'admTime',
            title: '时间'
        }, {
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
        //}, {
        //    field: 'PCSTime',
        //    align: 'center',
        //    title: 'T'
        }, {
            field: 'PCSTemp',  //体温T 2016-09-03 congyue
            align: 'center',
            title: 'T'
        }, {
            field: 'PCSHeart',
            align: 'center',
            title: 'P'
        }, {
            field: 'PCSPCSPulse',
            align: 'center',
            title: 'R'
        }, {
            field: 'PCSBP', //BP 2016-09-03 congyue
            align: 'center',
            title: 'BP'        
        }, {
            field: 'tel',
            align: 'center',
            title: '电话'
        }, {
            field: 'PCLNurseLevel',
            align: 'center',
            title: '分级'
        }, {
            field: 'curmarkno',
            align: 'center',
            title: '科室'
        }, {
            field: 'PCLAdmWay',
            align: 'center',
            title: '来诊方式'
        }, {
            field: 'PCLPatAskFlag',
            align: 'center',
            title: '假条'
        }, {
            field: 'MRDiagnos',
            align: 'center',
            title: '诊断'
        //}, {
        //    field: 'ID',
        //    align: 'center',
        //    title: 'ID'
        }, {
            field: 'EpisodeIDYY',
            align: 'center',
            title: '预检分级IDYY'
        }],
        queryParam:{
			regNo:$('#Regno').val(),    
    		//fromDate:$('#StartDate').getDate(),
    		//toDate:$('#EndDate').getDate()
    		fromDate:$('#StartDate input').val(),
    		toDate:$('#EndDate input').val(),
    		MarkNo:$('#Loc').val()
		},
		onDblClickRow:function(row){
			window.location.href="dhcem.patchecklev.csp?EpisodeID=77522";	
			}
    })
	//查找按钮导出按钮 保存按钮
    $("#searchBtn").on('click',function(){	
		search();
	})
	///清空科室下拉
	//$("#clearLoc").on('click',function(){	
	//	clearLoc();
	//})
	///导出
	$("#exportBtn").on('click',function(){	
		expExcel();
	})
	//$("#saveyBtn").on('click',function(){	
	//	save();
	//})
	//结束开始日期
	  $('#EndDate').dhccDate();
	  $("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
   
      $('#StartDate').dhccDate();
      $("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	


});
/////////////////
///CreatDate：   2016-05-09 
///Creator：    huaxiaoying
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#PHCode,#PHDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'PHActiveFlag':'Y','PHHospDr':'2'}})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMPatHistory","SavePatHis","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)				
			}
		});	
}

function cancel(){	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMPatHistory","RemovePatHis",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

/////////////////

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
	var Note=""
    $("input[type=checkbox][name=Note]").each(function(){
		if($(this).is(':checked')){
			Note=this.value;
		}
	})	

	$('#registerTb').dhccQuery({
		query:{
			regNo:$('#Regno').val(),    
    		fromDate:$('#StartDate input').val(),
    		toDate:$('#EndDate input').val(),
    		MarkNo:$('#Loc').val(),
    		AdmWay:$('#from').val(),
    		StaTime:$('#startTime input').val(),
    		EndTime:$('#endTime input').val(),
    		Note:Note
			}
	}) 

}
//function save(){
//	alert(3);
//}

///补零方法
function RegNoBlur()
{
	var i;
    var Regno=$('#Regno').val();
    var oldLen=Regno.length;
    if (oldLen==8) return;
	if (Regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	Regno="0"+Regno 
	    }
	}
    $("#Regno").val(Regno);
}

/*///导出
function expExcel()
{      
 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	 xlsBook = xlsExcel.Workbooks.Add() 
  		 // xlsBook = xlsExcel.Workbooks.Add(fileName) 
    	xlsSheet = xlsBook.ActiveSheet; 
    
    	xlsExcel.Visible = true;  
   
    	xlsSheet.cells(1,5)="   首都医科大学附属北京友谊医院 "
  	  	xlsSheet.cells(2,5)="           急诊登记";
    
    	xlsSheet.cells(3,1)="序号";
		xlsSheet.cells(3,2)="日期";
	   	xlsSheet.cells(3,3)="时间";
	    xlsSheet.cells(3,4)="登记号";
	    xlsSheet.cells(3,5)="姓名";
	    xlsSheet.cells(3,6)="性别";
	    xlsSheet.cells(3,7)="年龄";
	    xlsSheet.cells(3,8)="症状";
	    xlsSheet.cells(3,9)="T";
	    xlsSheet.cells(3,10)="P";
	    xlsSheet.cells(3,11)="R";
	    xlsSheet.cells(3,12)="BP";
	    xlsSheet.cells(3,13)="电话";
	    xlsSheet.cells(3,15)="分级";
	    xlsSheet.cells(3,16)="科室";
	    xlsSheet.cells(3,17)="来诊方式";
	    xlsSheet.cells(3,18)="假条";
	    xlsSheet.cells(3,19)="诊断";
	    //xlsSheet.cells(3,10)="诊断";
	    //xlsSheet.cells(3,11)="住址";
	    //xlsSheet.cells(3,12)="电话";
	   
	
    //var objtbl=document.getElementById('tDHCNurEmergencyYY');
    //var strj=$('#registerTb').dhccTableM('getData')[0].admDate;
     var strjLen=$('#registerTb').dhccTableM('getData').length
     
     for (i=1;i<=strjLen;i++)
    { 
	    xlsSheet.cells(i+3,1)=$('#registerTb').dhccTableM('getData')[i-1].num;
		xlsSheet.cells(i+3,2)=$('#registerTb').dhccTableM('getData')[i-

1].admDate;
	    xlsSheet.cells(i+3,3)=$('#registerTb').dhccTableM('getData')[i-1].admTime;
	    xlsSheet.cells(i+3,4)="'"+$('#registerTb').dhccTableM('getData')[i-

1].currregno;
	    xlsSheet.cells(i+3,5)=$('#registerTb').dhccTableM('getData')[i-1].name;
	    xlsSheet.cells(i+3,6)=$('#registerTb').dhccTableM('getData')[i-1].sex;
	    xlsSheet.cells(i+3,7)=$('#registerTb').dhccTableM('getData')[i-1].age;
	    xlsSheet.cells(i+3,8)=$('#registerTb').dhccTableM('getData')[i-1].symptom;
	    xlsSheet.cells(i+3,9)=$('#registerTb').dhccTableM('getData')[i-1].PCSTime;
	    xlsSheet.cells(i+3,10)=$('#registerTb').dhccTableM('getData')[i-1].PCSHeart;
	    xlsSheet.cells(i+3,11)=$('#registerTb').dhccTableM('getData')[i-

1].PCSPCSPulse;
	    xlsSheet.cells(i+3,12)=$('#registerTb').dhccTableM('getData')[i-1].PCSSBP;
	    xlsSheet.cells(i+3,13)="'"+$('#registerTb').dhccTableM('getData')[i-1].tel;
	    xlsSheet.cells(i+3,15)=$('#registerTb').dhccTableM('getData')[i-

1].PCLNurseLevel;
	    xlsSheet.cells(i+3,16)=$('#registerTb').dhccTableM('getData')[i-

1].curmarkno;
	    xlsSheet.cells(i+3,17)=$('#registerTb').dhccTableM('getData')[i-

1].PCLAdmWay;
	    xlsSheet.cells(i+3,18)=$('#registerTb').dhccTableM('getData')[i-

1].PCLPatAskFlag;
	    xlsSheet.cells(i+3,19)=$('#registerTb').dhccTableM('getData')[i-

1].MRDiagnos;
	   
	    //xlsSheet.cells(i+3,10)=document.getElementById('MRDiagnosz'+i).innerText;
	    //xlsSheet.cells(i+3,11)=document.getElementById('homeAddresz'+i).innerText;
	    //xlsSheet.cells(i+3,12)=document.getElementById('telz'+i).innerText;

 	 }
	    
       xlsSheet.Columns.AutoFit; 
	   xlsExcel.ActiveWindow.Zoom = 75 
	   xlsExcel.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由

用户控制 

	 xlsExcel=null; 
     xlsBook=null; 
     xlsSheet=null; 

	 //xlsSheet.printout
    //xlsSheet = null;
    //xlsBook.Close(savechanges=false);
    //xlsBook = null;
    //xlsExcel.Quit();
    //xlsExcel = null;

}*/
//导出 2016-09-21 congyue
function expExcel()
{
	///获取导出数据 cy
	var strjLen=0; 
 	var strjData="";	
	runClassMethod("web.DHCEMRegister","GetRegisterNew","",
	function(data){ 
		strjData=data;
		strjLen=data.length;
	},'json',false)
	
	var TemplatePath="";
	var xlsApp,xlsSheet,xlsBook;
	runClassMethod("web.UDHCJFCOMMON","getpath",{'itmjs':'','itmjsex':''},function

(jsonString){
		TemplatePath = jsonString;
	},'',false)
	
	TemplatePath=TemplatePath+"DHCEM_Register.xls"; //cy
	xlsApp = new ActiveXObject("Excel.Application");
	//alert(TemplatePath)
	xlsBook = xlsApp.Workbooks.Add(TemplatePath);
	     
	
	xlsSheet = xlsBook.ActiveSheet;
	xlsSheet.PageSetup.LeftMargin=0;  
	xlsSheet.PageSetup.RightMargin=0;
	xlsSheet.Application.Visible = true;

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
	    xlsSheet.cells(i+2,13)="'"+strjData[i-1].PCSBP; //BP cy
	    xlsSheet.cells(i+2,14)="'"+strjData[i-1].tel;
	    xlsSheet.cells(i+2,15)=strjData[i-1].PCLNurseLevel; //考虑到有推荐分级，如果护士录入分级，则取护士分级，否则取推荐分级 cy
	    xlsSheet.cells(i+2,16)=strjData[i-1].curmarkno;	   
	    xlsSheet.cells(i+2,17)=strjData[i-1].PCLAdmWay;
	    xlsSheet.cells(i+2,18)=strjData[i-1].PCLPatAskFlag;
	    xlsSheet.cells(i+2,19)=strjData[i-1].MRDiagnos;
	    
 	 }
 	 gridlist(xlsSheet,1,strjLen+2,1,19)
     xlsSheet.Columns.AutoFit; 
	 xlsExcel.ActiveWindow.Zoom = 75 
	 xlsExcel.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 

	 xlsExcel=null; 
     xlsBook=null; 
     xlsSheet=null; 

	 //xlsSheet.printout
    //xlsSheet = null;
    //xlsBook.Close(savechanges=false);
    //xlsBook = null;
    //xlsExcel.Quit();
    //xlsExcel = null;

}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders

(4).Weight=2
}
