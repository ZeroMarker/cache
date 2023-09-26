/// Creator: qiaoqingao
/// CreateDate: 2017-01-05

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

//��ʼ������
function initParam(){
	//��;����ȡ��̨����
	$.ajax({
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
		})
		
	rowData="";                 //ѡ��������ȫ�ֱ���
}

function initLayout(){
	
	}

function initDate(){
	//������ʼ����
	$('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	

	$('#StartDate').dhccDate();
	$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
	}


function initCombo(){
	
	
	$('#ApplayLoc').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	
	$('#AffirmStatus').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetAffirmStatus",
		minimumResultsForSearch:-1  
	});
	}

function initTable(){
	
	var columns = [
        {
	        title: 'ѡ��',
            checkbox: true
        }, {
	        field: 'newStatus',
            title: '��ǰ״̬'
	       },{
            field: 'applyDate',
            title: '��������'
        }, {
            field: 'applyTime',
            title: '����ʱ��'
        },  {
            field: 'currregNo',
            title: '�ǼǺ�'
        }, {
            field: 'bedNo',
            align: 'center',
            title: '����'
        }, {
            field: 'endemicArea',
            align: 'center',
            title: '����'
        }, {
            field: 'taskID',
            align: 'center',
            title: '����ID'  
        }, {
            field: 'acceptLoc',
            align: 'center',
            title: '���ܿ���'
        }, { 
            field: 'deliveryDate',
            align: 'center',
            title: '��������' //��ʶ״̬
        }, { 
            field: 'deliveryTime',
            align: 'center',
            title: '����ʱ��' //��ʶ״̬
        }, {
            field: 'deliveryWay',  //����T 2016-09-03 congyue
            align: 'center',
            title: '���ͷ�ʽ'
        }, {
            field: 'deliveryType',
            align: 'center',
            title: '��������'
        }, {
            field: 'remarkDesc',
            align: 'center',
            title: '��ע'
        }]
	var param=getParam();                                 //��ȡ����
	//data=$("#execTable").dhccTableM("getSelections");
    $('#cspAffirmStatusTb').dhccTable({
	    height:$(window).height()-300,
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
		url: LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param,
        singleSelect:true,
        columns: columns,
        onCheck:function(row, $ele){
	        rowData= row;
	        
	    },
	    onUncheck:function (row, $ele){
			rowData= "";
		}
    })

var columns = [
		{
            field: 'projectName',
            align: 'center',
            title: '��Ŀ����'
        },{
            field: 'toBourn',
            align: 'center',
            title: 'ȥ��'
        },
	]

$('#cspAffirmStatusCarefulTb').dhccTable({
	    height:$(window).height()-500,
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
        //url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        data:[
        ],
        singleSelect:true,
        columns: columns,
        queryParam:{
	        
		}
    })
}	
	
function initMethod(){
	 //�س��¼�
     $('#Regno').bind('keypress',RegNoBlur);
     
     $('#verifiBtn').bind('click',verifiDis); //��֤ȷ��
     $('#exeBtn').bind('click',exeDis);       //����ȷ��
 	
 	 $('#searchBtn').bind('click',search)	
 
     //�������¼�
     $("#particulars").on('click',function(){
		particulars();   //����
	 })
	 $("#appraiseBtn").on('click',function(){
	 	particulars();   //
	 })
	$("#unfiniBtn").on('click',function(){
	 	particulars();   //δ���                  
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

//��֤ȷ��
function verifiDis(){
	if((rowData=="")){
			dhccBox.alert("��ѡ������һ����¼��","affirmdetail")
			return;	
		}
		
	var param = {
		mainID:rowData.mainRowID
		}
	runClassMethod("web.DHCDISAffirmStatus","insetNewStatus","",
		function(data){ 
			alert(data);
		},'text',false)
	}

//����ȷ��
function exeDis(){
	if((rowData=="")){
			dhccBox.alert("��ѡ������һ����¼��","affirmdetail")
			return;	
		}
	dhccBox.confirm("����ȷ��","ȷ�Ͻ�������״̬��Ϊ�����","affirmDis",
		function(){
			//ȷ����ǰ״̬�Ƿ����ó����
			//���ú�̨������״̬
			//���ظ�ǰ̨��״̬���
		}
	)
}

//��ѯ
function search(){
	
}

//���� lvpeng 16-1-7
function particulars(){
	if((rowData=="")){
			dhccBox.alert("��ѡ������һ����¼��","affirmdetail")
			return;	
		}
		
	var thisID = $(event.target).attr("id");
	//��ϸ����
	if (thisID=="particulars"){
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

//Table�������
//return ����ʼʱ��^����ʱ��^����ID^�ǼǺ�^�������^״̬
function getParam(){
	var stDate = $('#StartDate').getDate();
	var endDate=$('#EndDate').getDate();
	var taskID= $('#TaskID').val();
	var regno = $('#Regno').val();
	var applayLocDr= $('#ApplayLoc').val();
	var affirmStatus = $('#AffirmStatus').val();
	return stDate+"^"+endDate+"^"+taskID+"^"+applayLocDr+"^"+applayLocDr+"^"+affirmStatus
	}