//var ordId="" //hxy 2016-12-29 2017-02-09ע��
$(document).ready(function() {

    $('#StDate').dhccDate();
	$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
    
    $('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
	
	//table������Ӧ 2017-02-09
	var rtime = new Date();
    var timeout = false;
    var delta = 66;
    $(window).resize(function(){
        rtime = new Date();
        if(timeout == false){
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });
    function resizeend(){
        if(new Date() - rtime < delta){
            setTimeout(resizeend, delta);
        }else{
            timeout = false;
            $('#detailtable').dhccTableM("resetWidth");
        }
    }//hxy 2017-02-09
    
		//ҽ�����б� 
  	height=($(window).height()-112)/2
	$('#table').dhccTable({
		pageSize:6000, //hxy 2017-01-17
		pageList:[6000,12000], //hxy 2017-01-17
	    height:height,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatThisOrd&MethodName=GetOrdByAdmDataToJson&AdmId='+EpisodeID,
        singleSelect:true,
        columns:[
		{field: 'ActiveQtySum',title: '�ܼ�'},
		{field: 'ArcPrice',title: '����'},
		{field: 'OrdCreateDate',title: '��������'}, 
		{field: 'OrdCreateTime',title: '����ʱ��'},
		{field: 'OrdStartDate',title: '��ʼ����'},
		{field: 'OrdStartTime',title: '��ʼʱ��'},
		{field: 'ArcimDesc',title: 'ҽ������',formatter:orderName},
		{field: 'DoseQty',title: '����'},
		{field: 'DoseUnit',title: '��λ'},
		{field: 'PHFreq',title: 'Ƶ��'},
		{field: 'Priority',title: '���ȼ�'},
		{field: 'Instr',title: '�÷�'},
		{field: 'doctor',title: 'ҽ��'},
		{field: 'Dura',title: '�Ƴ�'},
		{field: 'OrdStatus',title: 'ҽ��״̬'},
		{field: 'OrdAction',title: 'Ƥ�Ա�ע'},
		{field: 'OrdDepProcNotes',title: '��ע'},
		{field: 'OEItemID',title: 'OEORI_RowId'},
		{field: 'OrdXDate',title: 'ֹͣ����'},
		{field: 'OrdBilled',title: '�Ʒ�'},
		{field: 'EndTime',title: 'Ԥͣʱ��'},
		{field: 'BillType',title: '�ѱ�'},
		{field: 'ActiveQty',title: 'ʵ������'}, 
		{field: 'MaterialBarCode',title: '��ֵ����'}, 
		{field: 'ToInpatient',title: 'ҽ����Դ'}, 
		{field: 'Pqty',title: '����'},
		{field: 'PrescNo',title: '������'},
		{field: 'OrdSkinTestResult',title: 'Ƥ�Խ��'}
		],
		onClickRow:function(row, $element, field){
			//ordId=row.OEItemID;//hxy 2016-12-29
		    $('#detailtable').dhccQuery({query:{regNo:RegNo,userId:LgUserID,startDate:$("#StDate").getDate(),endDate:$("#EndDate").getDate(),admType:"OE",DetailFlag:"on",ordId:row.OEItemID}})
		}
    });
    $('#detailtable').dhccTable({
	    height:height,
        url:'dhcapp.broker.csp?ClassName=web.DHCNurCom&MethodName=FindOrditemAttach&IsQuery=Y',
        singleSelect:true,
        columns:[
		{field: 'admDeptDesc',title: '�������'},
		{field: 'orcatDesc',title: 'ҽ������'},
		{field: 'arcimDesc',title: 'ҽ������'}, 
		{field: 'phOrdQtyUnit',title: '����'},
		{field: 'price',title: '����'},
		{field: 'totalAmount',title: '�ܼ�'},
		{field: 'ctcpDesc',title: '��ҽ����',formatter:orderName},
		{field: 'reclocDesc',title: '���տ���'},
		{field: 'createDateTime',title: '��ҽ��ʱ��'},
		{field: 'sttDateTime',title: 'Ҫ��ִ��ʱ��'},
		{field: 'ordStatDesc',title: 'ҽ��״̬'},
		{field: 'phcduDesc1',title: '�Ƴ�'},
		{field: 'oeoriId',title: 'oeoriId'},
		{field: 'disposeStatCode',title: 'disposeStatCode'}
		]
    });
    
    /*window.onresize=resizeBannerImage;
	function resizeBannerImage(){
	$('#detailtable').dhccQuery({query:{regNo:RegNo,userId:LgUserID,startDate:$("#StDate").getDate(),endDate:$("#EndDate").getDate(),admType:"OE",DetailFlag:"on",ordId:ordId}})
	} //huaxiaoying 2016-12-29 */
    
 function orderName(value,rowData,rowIndex){
	return "<b class='ordertitle'>"+value+"</b>" ;
 }
  $("#QueryBTN").on('click',function(){
	  	start=serverCall("web.DHCEMPatThisOrd","TransDate",{Date:$("#StDate").getDate()});
		end=serverCall("web.DHCEMPatThisOrd","TransDate",{Date:$("#EndDate").getDate()});
		check=$('input[name="ordFlag"]:checked').val()
		LongOrd=(check=='LongOrd'?"on":"")
		ShortOrd=(check=='ShortOrd'?"on":"")
		$('#table').dhccQuery({query:{SearchStartDate:start,SearchEndDate:end,LongOrd:LongOrd,ShortOrd:ShortOrd}})

  })   	
});
	