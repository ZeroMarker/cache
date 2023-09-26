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

///��ʼ������
function initParams(){
	DateFormat = "";
	runClassMethod("web.DHCEMRegister","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
}

///�󶨷���
function initMethod(){
	$('#regno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur()
        }
    });	
    
    //���Ұ�ť������ť ���水ť
    $("#searchBtn").on('click',function(){	
		search();
	})

	///����
	$("#exportBtn").on('click',function(){	
		expExcel();
	})
	
}

///��ʼ��combobox
function initCombobox(){
	$(".prev").parent().css("visibility","hidden"); //����
	//�ű�
	$HUI.combobox("#loc",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=getEmeNumInfo&hosp="+hosp,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	//���﷽ʽ
	$HUI.combobox("#from",{
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=ListPatAdmWay" ,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	//֢״
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
		data:[{'id':'1','text':'�����'},
			  {'id':'2','text':'����ҽ���һ��'},
			  {'id':'3','text':'����ҽ��϶���'}
			  ],
		onSelect:function(option){
	       
	    }	
	})	
	
	
	//�ű����
	$HUI.combobox("#levCareLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+hosp,
		valueField:'value',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
}

///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#startDate").setValue(formatDate(0-SEECHKDATE));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

function initDatagrid(){
	var columns = [[
        /*
        {
	        title: 'ѡ��',
            checkbox: true
         },
         */
        {
            field: 'num',
            title: '���'
        }, {
            field: 'admDate',
            title: '��������'
        }, {
            field: 'admTime',
            title: '����ʱ��'
        },{
            field: 'SeeDocDate',
            title: '��������'
        }, {
            field: 'SeeDocTime',
            title: '����ʱ��'
        }, {
            field: 'WaitTime',
            title: '�Ⱥ�ʱ��'
        },{
            field: 'currregno',
            title: '�ǼǺ�'
        }, {
            field: 'name',
            align: 'center',
            title: '����'
        }, {
            field: 'sex',
            align: 'center',
            title: '�Ա�'
        }, {
            field: 'age',
            align: 'center',
            title: '����'  
        }, {
            field: 'symptom',
            align: 'center',
            title: '֢״'
        }, { //2016-09-21 congyue
            field: 'EmAware',
            align: 'center',
            title: '��־' //��ʶ״̬
        }, {
            field: 'PCSTemp',  //����T 2016-09-03 congyue
            align: 'center',
            title: 'T(��)'
        }, {
            field: 'PCSHeart',
            align: 'center',
            title: 'HR(��/��)'
        }, {
            field: 'PCSPCSPulse',
            align: 'center',
            title: 'P(��/��)'
        }, {
            field: 'PCSBP', //BP 2016-09-03 congyue
            align: 'center',
            title: 'BP(mmHg)'        
        },{
            field: 'PCSR', //BP 2016-09-03 congyue
            align: 'center',
            title: 'R(��/��)'        
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
            title: '������¼',
            formatter:function(value,row,index){
				return '<a href="#" title="��ʷ"  onclick="openSignHis('+row.PCLRowID+')">��ʷ</a>';
			}        
        },{
            field: 'tel',
            align: 'center',
            title: '�绰'
        }, {
            field: 'PCLCareLoc',
            align: 'center',
            title: '�������'
        },{
            field: 'curmarkno',
            align: 'center',
            title: '�ű�'
        }, {
            field: 'PCLAdmWay',
            align: 'center',
            title: '���﷽ʽ'
        }, {
            field: 'IsGreenAdm',
            align: 'center',
            title: '��ɫͨ��'
        },{
            field: 'PCLPatAskFlag',
            align: 'center',
            title: '����',
            formatter:function(value,row,index){
				if (value=='Y'){return '��';} 
				else {return '��';}
			}//hxy 2018-10-22
        }, {
            field: 'SickHistory',
            align: 'center',
            title: '����ʷ'
        },
        {
            field: 'VeerLocDesc',
            align: 'center',
            title: 'ת�����'
        },
         {
            field: 'NurseLevel',
            align: 'center',
            title: '��ʿ�ּ�',
            formatter:setCellLabel  //hxy 2020-02-20
        },
         {
            field: 'PCLNurUser',
            align: 'center',
            title: '���ﻤʿ'
        }]]
        
  
	$HUI.datagrid('#registerTable',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'�����ѯ', //hxy 2018-10-09 st
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
		title: '��������������ʷ��ѯ',
		closed: true,
		onClose:function(){}
	});
}

///  Ч��ʱ����¼�����ݺϷ��� add 2016-09-23
function CheckDHCCTime(id){
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		dhccBox.alert("��¼����ȷ��ʱ���ʽ������:18:23,��¼��1823","register-three");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		//dhccBox.alert("�ҵ�message","classname");
		dhccBox.alert("Сʱ�����ܴ���23��","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("���������ܴ���59��","register-one");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}

/// ��ȡ�����ʱ�������� add 2016-09-23
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
///��տ�������
function clearLoc(){
	$('#Loc').val("");	
	$("#Loc").attr("title","");
	$("#Loc").empty();
}	
///���Ұ�ť
function search(){
	
	$HUI.datagrid('#registerTable').load({
		Params:getParams()
	})
	return ;

}
//function save(){
//	alert(3);
//}

///���㷽��
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

///��ȡParams
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

//���� 2016-09-21 congyue
function expExcelOld()
{
	///��ȡ�������� cy
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
	
	xlsSheet.cells(2,1)="���";  
	xlsSheet.cells(2,2)="��������";
   	xlsSheet.cells(2,3)="����ʱ��";
    xlsSheet.cells(2,4)="�ǼǺ�";
    xlsSheet.cells(2,5)="����";
    xlsSheet.cells(2,6)="�Ա�";
    xlsSheet.cells(2,7)="����";
    xlsSheet.cells(2,8)="֢״";
    xlsSheet.cells(2,9)="��־";
    xlsSheet.cells(2,10)="T(��)";
    xlsSheet.cells(2,11)="HR(��/��)";
    xlsSheet.cells(2,12)="P(��/��)";
    xlsSheet.cells(2,13)="BP(mmHg)";
    xlsSheet.cells(2,14)="R(��/��)";
    xlsSheet.cells(2,15)="SPO2(%)";
    xlsSheet.cells(2,16)="Glu(mmol/l) ";
    xlsSheet.cells(2,17)="�绰";
    xlsSheet.cells(2,18)="�ּ�";
    xlsSheet.cells(2,19)="�ű�";
    xlsSheet.cells(2,20)="���﷽ʽ";
    xlsSheet.cells(2,21)="����";
    xlsSheet.cells(2,22)="ת�����";
    xlsSheet.cells(2,23)="����ʷ";
    xlsSheet.cells(2,24)="�������";
	//xlsSheet.cells(1,1) = "��������ҽԺ";   //QQA  2016-10-16
    for (i=1;i<=strjLen;i++)
    { 
	    xlsSheet.cells(i+2,1)=strjData[i-1].num;
		xlsSheet.cells(i+2,2)=strjData[i-1].admDate;
	    xlsSheet.cells(i+2,3)=strjData[i-1].admTime;
	    xlsSheet.cells(i+2,4)="'"+strjData[i-1].currregno;
	    xlsSheet.cells(i+2,5)=strjData[i-1].name;
	    xlsSheet.cells(i+2,6)=strjData[i-1].sex;
	    xlsSheet.cells(i+2,7)=strjData[i-1].age;
	    xlsSheet.cells(i+2,8)=strjData[i-1].symptom; //֢״=֢״�ֵ��¼��+������д������ cy
	    xlsSheet.cells(i+2,9)=strjData[i-1].EmAware; //��ʶ״̬ cy
	    xlsSheet.cells(i+2,10)=strjData[i-1].PCSTemp; //����T cy
	    xlsSheet.cells(i+2,11)=strjData[i-1].PCSHeart;
	    xlsSheet.cells(i+2,12)=strjData[i-1].PCSPCSPulse;
	    xlsSheet.cells(i+2,13)=strjData[i-1].PCSBP; //BP cy
	    xlsSheet.cells(i+2,14)=strjData[i-1].PCSR
	    xlsSheet.cells(i+2,15)=strjData[i-1].EmPcsSoP2
	    xlsSheet.cells(i+2,16)=strjData[i-1].EmPcsGLU
	    xlsSheet.cells(i+2,17)="'"+strjData[i-1].tel;
	    xlsSheet.cells(i+2,18)=setCell(strjData[i-1].PCLNurseLevel); //���ǵ����Ƽ��ּ��������ʿ¼��ּ�����ȡ��ʿ�ּ�������ȡ�Ƽ��ּ� cy //hxy 2020-02-20
	    xlsSheet.cells(i+2,19)=strjData[i-1].curmarkno;	   
	    xlsSheet.cells(i+2,20)=strjData[i-1].PCLAdmWay;
	    xlsSheet.cells(i+2,21)=strjData[i-1].PCLPatAskFlag;
	    xlsSheet.cells(i+2,22)=strjData[i-1].VeerLocDesc;
	    xlsSheet.cells(i+2,23)=strjData[i-1].SickHistory;
	    xlsSheet.cells(i+2,24)=strjData[i-1].PCLCareLoc;
	    
 	 }
 	 gridlist(xlsSheet,1,strjLen+2,1,24)
     xlsSheet.Columns.AutoFit; 
   
     
    succflag=xlsBook.SaveAs("�����ѯ.xls");
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
	if(value=="1��"){value="��";}
	if(value=="2��"){value="��";}
	if(value=="3��"){value="��";}
	if(value=="4��"){value="��a��";}
	if(value=="5��"){value="��b��";}
	return value;
}
//hxy 2020-02-20
function setCell(value){
	if(value=="1"){value="��";}
	if(value=="2"){value="��";}
	if(value=="3"){value="��";}
	if(value=="4"){value="��a";}
	if(value=="5"){value="��b";}
	return value;
}

//���� 2020-04-08 hxy
function expExcel()
{
	///��ȡ�������� 
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
	
	Str=Str+"xlSheet.cells(2,1).value='���';";
	Str=Str+"xlSheet.cells(2,2).value='��������';";
	Str=Str+"xlSheet.cells(2,3).value='����ʱ��';";
	Str=Str+"xlSheet.cells(2,4).value='�ǼǺ�';";
	Str=Str+"xlSheet.cells(2,5).value='����';";
	Str=Str+"xlSheet.cells(2,6).value='�Ա�';";
	Str=Str+"xlSheet.cells(2,7).value='����';";
	Str=Str+"xlSheet.cells(2,8).value='֢״';";
	Str=Str+"xlSheet.cells(2,9).value='��־';";
	Str=Str+"xlSheet.cells(2,10).value='T(��)';";
	Str=Str+"xlSheet.cells(2,11).value='HR(��/��)';";
	Str=Str+"xlSheet.cells(2,12).value='P(��/��)';";
	Str=Str+"xlSheet.cells(2,13).value='BP(mmHg)';";
	Str=Str+"xlSheet.cells(2,14).value='R(��/��)';";
	Str=Str+"xlSheet.cells(2,15).value='SPO2(%)';";
	Str=Str+"xlSheet.cells(2,16).value='Glu(mmol/l)';";
	Str=Str+"xlSheet.cells(2,17).value='�绰';";
	Str=Str+"xlSheet.cells(2,18).value='�ּ�';";
	Str=Str+"xlSheet.cells(2,19).value='�ű�';";
	Str=Str+"xlSheet.cells(2,20).value='���﷽ʽ';";
	Str=Str+"xlSheet.cells(2,21).value='����';";
	Str=Str+"xlSheet.cells(2,22).value='ת�����';";
	Str=Str+"xlSheet.cells(2,23).value='����ʷ';";
	Str=Str+"xlSheet.cells(2,24).value='�������';";
	
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
	    Str=Str+"xlSheet.cells("+(i+2)+",8).value='"+strjData[i-1].symptom+"';"; //֢״=֢״�ֵ��¼��+������д������
	    Str=Str+"xlSheet.cells("+(i+2)+",9).value='"+strjData[i-1].EmAware+"';"; //��ʶ״̬
	    Str=Str+"xlSheet.cells("+(i+2)+",10).value='"+strjData[i-1].PCSTemp+"';"; //����T
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
	 Str=Str+"xlBook.SaveAs('�����ѯ.xls');"+
	 "xlApp.Visible=true;"+
	 "xlApp=null;"+
	 "xlBook=null;"+
	 "xlSheet=null;"+
     "return 1;}());";
     //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
     CmdShell.notReturn = 1;   //�����޽�����ã�����������
	 var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	 return;
}
