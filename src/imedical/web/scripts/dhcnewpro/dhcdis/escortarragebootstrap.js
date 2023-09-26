/// Creator: congyue
/// CreateDate: 2017-01-12
/// Descript: ���������ѯ����

var TagCode="",CategoryRowId="",Dep=1;
var BPRNSTR="";
var hospitalDesc;
var btOffset; //��ʼ����
var btLimit;  //һҳ������
var btTotal; //������
$(document).ready(function() {
	//��ʼ������
	initParam();
	
	//��ʼ������
	initLayout();
	
	//��ʼ��ʱ��ؼ�
	initDate();
	
	//��ʼ��combo
	initCombo();
	
	//��ʼ��bootstrap table
	initTable();
	
	//��ʼ���ؼ��󶨵��¼�
	initMethod();

});
function initParam(){
	/* $.ajax({
		url:LINK_CSP,
		data:{
			"ClassName":"web.DHCDISAffirmStatus",
	        "MethodName":"GetParamByInit"
		},
		type:'get',
		async:false,
		dataType:'json',
		success:function (data){
			Params = data;
		}
		}) */
	}

function initLayout(){
	
	}

function initDate(){
    //��ʼ����
    $('#StDate').dhccDate();
	$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
    //��������
    $('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
}


function initCombo(){
	$('#applyLoc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	
	$('#Status').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetAffirmStatus",
		minimumResultsForSearch:-1  
	});
}

function initTable(){
	
	var columns = [
		/* {
	        title: 'ѡ��',
            checkbox: true
        }, */ {
			field: 'OerdDate',
			title: '��������',
			align: 'center'
		}, {
			field: 'PatNo',
			title: '�ǼǺ�',
			align: 'center'
		}, {
			field: 'BedNo',
			title: '����',
			align: 'center'
		}, {
			field: 'Ward',
			title: '����',
			align: 'center'
		}, {
			field: 'TaskID',
			title: '����ID',
			align: 'center'
		}, {
			field: 'LocDesc',
			title: '���տ���',
			align: 'center'
		}, {
            field: 'EscDate',
            title: '��������',
            align: 'center'
        }, {
            field: 'EscMode',
            title: '���ͷ�ʽ',
            align: 'center'
        }, {
            field: 'EscTyoe',
            title: '��������',
            align: 'center'
        }, {
            field: 'Remark',
            title: '��ע',
            align: 'center'
        }]
	var param=getParam();
    $('#escortarragetb').dhccTable({
	    height:200,
        //idField: 'id',
	    pageSize:10,
	    pageList:[10,20],
	    striped:true,
       	url: '',//'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        singleSelect:true,
        columns: columns,
        onClickRow:function (row,$ele){
	        rowData=row;
	        }
    })


//ҽ�����б� 
    $('#escortarragetbs').dhccTable({
	    height:100,
	    pageSize:10,
	    pageList:[10,20],
        url: '',//'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        columns:  [{
			field: 'tt',
			title: '��Ŀ����',
			align: 'center'
		}, {
			field: 'hh',
			title: 'ȥ��',
			align: 'center'
		}] ,
		singleSelect:true/* ,
        queryParam:{
	        Symp:$("#Symptom option:selected").text(),  
	        PCLAdmWayNo:$('#from').val(),              
	        NurLevel:$('#level').val(),                 
			regNo:$('#Regno').val(),    
    		fromDate:$('#StartDate input').val(),
    		toDate:$('#EndDate input').val(),
    		MarkNo:$('#Loc').val()
		} */
    })
}	
	
function initMethod(){
	 //�س��¼�
     $('#Regno').bind('keypress',RegNoBlur)
     //�������¼�
     $("#particulars").on('click',function(){
		particulars();
	 })
	 $("#appraiseBtn").on('click',function(){
	 	particulars();
	 })
	$("#unfiniBtn").on('click',function(){
	 	particulars();
	 })
}	



/*======================================================*/

//�ǼǺŻس��¼�
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#Regno').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    dhccBox.alert("�ǼǺų�����������","affirm");
		    $('#Regno').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#Regno").val(Regno);
    }
};

//���� lvpeng 16-1-7
function particulars(){
	
	var thisID = $(event.target).attr("id");
	//��ϸ����
	if (thisID=="particulars"){
		var data=$('#cspAffirmStatusTb').dhccTableM("getSelections");
		if((data.length==0)){
			dhccBox.alert("��ѡ������һ����¼��","affirmdetail")
			return;	
		}
		//alert(rowData.mainRowID)
		option={
			title:'������ϸ',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','400px'],
	  		content: 'dhcdis.disdetail.csp?mainRowID='+rowData.mainRowID
		}
	}
	//���ֽ���
	if (thisID=="appraiseBtn"){
		option={
			title:'����',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','500px'],
	  		content: 'dhcdis.disappraise.csp?mainRowID='+rowData.mainRowID
		}	
	}
	
	//δ���ԭ��
	if (thisID=="unfiniBtn"){
		option={
			title:'δ���ԭ��',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['650px','500px'],
	  		content: 'dhcdis.failreason.csp?mainRowID='+rowData.mainRowID
		}	
	}
	
	layer.open(option);	
}


function getParam(){
	return "^^^^^";
	}
/// 2016/8/24 11:31:29
/// Title��������ʽ�޸�
function orderName(value,rowData,rowIndex){
	return "<b class='ordertitle'>"+value+"</b>" ;
	}

function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
function StuModel(){
	
   $('#StPage').val("");
   $('#StRow').val("");
   $('#EdPage').val("");
   $('#EdRow').val("");
}
function StModel(){
	
   $('#EdRow').val("");
}

/// add lvpeng 16-12-29
/* function search(){
	if($('#OrdLong').attr('checked')=="checked"){
		findLong();	//����
	}if($('#OrdTemp').attr('checked')=="checked"){
		Temp_click(); //����
	}if($('#SelDate').is(':checked')){
		//��ʼ����
    	StDate=$('#StDate input').val();
    	//��������
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("��ѡ��ʼ�������������");
			return;   //ssuser
		}
		
	}
} */
