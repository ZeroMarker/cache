/// Creator: huaxiaoying
/// CreateDate: 2016-08-15
var Regno="";
$(function(){ 
    //$("#Regno").val("0000000001"); //Ҫɾ��
	//�س��¼�
     $('#Regno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur()
        }
    });
});
$(document).ready(function() {
	$(".prev").parent().css("visibility","hidden"); //����
	$(".prev").css("visibility","hidden");
	//$(".prev").next().css("visibility","hidden");
	$(".next").css("visibility","hidden");
	//$(".prev").parent().parent().next().css("width","200px");
	//�������
	$('#Loc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=FindMarkNo"   
	});
	//���﷽ʽ
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
            title: '���'
        }, {
            field: 'admDate',
            title: '����'
        }, {
            field: 'admTime',
            title: 'ʱ��'
        }, {
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
        //}, {
        //    field: 'PCSTime',
        //    align: 'center',
        //    title: 'T'
        }, {
            field: 'PCSTemp',  //����T 2016-09-03 congyue
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
            title: '�绰'
        }, {
            field: 'PCLNurseLevel',
            align: 'center',
            title: '�ּ�'
        }, {
            field: 'curmarkno',
            align: 'center',
            title: '����'
        }, {
            field: 'PCLAdmWay',
            align: 'center',
            title: '���﷽ʽ'
        }, {
            field: 'PCLPatAskFlag',
            align: 'center',
            title: '����'
        }, {
            field: 'MRDiagnos',
            align: 'center',
            title: '���'
        //}, {
        //    field: 'ID',
        //    align: 'center',
        //    title: 'ID'
        }, {
            field: 'EpisodeIDYY',
            align: 'center',
            title: 'Ԥ��ּ�IDYY'
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
	//���Ұ�ť������ť ���水ť
    $("#searchBtn").on('click',function(){	
		search();
	})
	///��տ�������
	//$("#clearLoc").on('click',function(){	
	//	clearLoc();
	//})
	///����
	$("#exportBtn").on('click',function(){	
		expExcel();
	})
	//$("#saveyBtn").on('click',function(){	
	//	save();
	//})
	//������ʼ����
	  $('#EndDate').dhccDate();
	  $("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
   
      $('#StartDate').dhccDate();
      $("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	


});
/////////////////
///CreatDate��   2016-05-09 
///Creator��    huaxiaoying
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#PHCode,#PHDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'PHActiveFlag':'Y','PHHospDr':'2'}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMPatHistory","SavePatHis","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)				
			}
		});	
}

function cancel(){	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMPatHistory","RemovePatHis",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

/////////////////

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

///���㷽��
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

/*///����
function expExcel()
{      
 	 	xlsExcel = new ActiveXObject("Excel.Application");
 	 	 xlsBook = xlsExcel.Workbooks.Add() 
  		 // xlsBook = xlsExcel.Workbooks.Add(fileName) 
    	xlsSheet = xlsBook.ActiveSheet; 
    
    	xlsExcel.Visible = true;  
   
    	xlsSheet.cells(1,5)="   �׶�ҽ�ƴ�ѧ������������ҽԺ "
  	  	xlsSheet.cells(2,5)="           ����Ǽ�";
    
    	xlsSheet.cells(3,1)="���";
		xlsSheet.cells(3,2)="����";
	   	xlsSheet.cells(3,3)="ʱ��";
	    xlsSheet.cells(3,4)="�ǼǺ�";
	    xlsSheet.cells(3,5)="����";
	    xlsSheet.cells(3,6)="�Ա�";
	    xlsSheet.cells(3,7)="����";
	    xlsSheet.cells(3,8)="֢״";
	    xlsSheet.cells(3,9)="T";
	    xlsSheet.cells(3,10)="P";
	    xlsSheet.cells(3,11)="R";
	    xlsSheet.cells(3,12)="BP";
	    xlsSheet.cells(3,13)="�绰";
	    xlsSheet.cells(3,15)="�ּ�";
	    xlsSheet.cells(3,16)="����";
	    xlsSheet.cells(3,17)="���﷽ʽ";
	    xlsSheet.cells(3,18)="����";
	    xlsSheet.cells(3,19)="���";
	    //xlsSheet.cells(3,10)="���";
	    //xlsSheet.cells(3,11)="סַ";
	    //xlsSheet.cells(3,12)="�绰";
	   
	
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
	   xlsExcel.UserControl = true;  //����Ҫ,����ʡ��,��Ȼ������� ��˼��excel����

�û����� 

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
//���� 2016-09-21 congyue
function expExcel()
{
	///��ȡ�������� cy
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
	    xlsSheet.cells(i+2,8)=strjData[i-1].symptom; //֢״=֢״�ֵ��¼��+������д������ cy
	    xlsSheet.cells(i+2,9)=strjData[i-1].EmAware; //��ʶ״̬ cy
	    xlsSheet.cells(i+2,10)=strjData[i-1].PCSTemp; //����T cy
	    xlsSheet.cells(i+2,11)=strjData[i-1].PCSHeart;
	    xlsSheet.cells(i+2,12)=strjData[i-1].PCSPCSPulse;
	    xlsSheet.cells(i+2,13)="'"+strjData[i-1].PCSBP; //BP cy
	    xlsSheet.cells(i+2,14)="'"+strjData[i-1].tel;
	    xlsSheet.cells(i+2,15)=strjData[i-1].PCLNurseLevel; //���ǵ����Ƽ��ּ��������ʿ¼��ּ�����ȡ��ʿ�ּ�������ȡ�Ƽ��ּ� cy
	    xlsSheet.cells(i+2,16)=strjData[i-1].curmarkno;	   
	    xlsSheet.cells(i+2,17)=strjData[i-1].PCLAdmWay;
	    xlsSheet.cells(i+2,18)=strjData[i-1].PCLPatAskFlag;
	    xlsSheet.cells(i+2,19)=strjData[i-1].MRDiagnos;
	    
 	 }
 	 gridlist(xlsSheet,1,strjLen+2,1,19)
     xlsSheet.Columns.AutoFit; 
	 xlsExcel.ActiveWindow.Zoom = 75 
	 xlsExcel.UserControl = true;  //����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û����� 

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
