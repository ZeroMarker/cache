//var ordId="" //hxy 2016-12-29 2017-02-09注释
$(document).ready(function() {

    $('#StDate').dhccDate();
	$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
    
    $('#EndDate').dhccDate();
	$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
	
	//table列自适应 2017-02-09
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
    
		//医嘱单列表 
  	height=($(window).height()-112)/2
	$('#table').dhccTable({
		pageSize:6000, //hxy 2017-01-17
		pageList:[6000,12000], //hxy 2017-01-17
	    height:height,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatThisOrd&MethodName=GetOrdByAdmDataToJson&AdmId='+EpisodeID,
        singleSelect:true,
        columns:[
		{field: 'ActiveQtySum',title: '总价'},
		{field: 'ArcPrice',title: '单价'},
		{field: 'OrdCreateDate',title: '下嘱日期'}, 
		{field: 'OrdCreateTime',title: '下嘱时间'},
		{field: 'OrdStartDate',title: '开始日期'},
		{field: 'OrdStartTime',title: '开始时间'},
		{field: 'ArcimDesc',title: '医嘱名称',formatter:orderName},
		{field: 'DoseQty',title: '剂量'},
		{field: 'DoseUnit',title: '单位'},
		{field: 'PHFreq',title: '频次'},
		{field: 'Priority',title: '优先级'},
		{field: 'Instr',title: '用法'},
		{field: 'doctor',title: '医生'},
		{field: 'Dura',title: '疗程'},
		{field: 'OrdStatus',title: '医嘱状态'},
		{field: 'OrdAction',title: '皮试备注'},
		{field: 'OrdDepProcNotes',title: '备注'},
		{field: 'OEItemID',title: 'OEORI_RowId'},
		{field: 'OrdXDate',title: '停止日期'},
		{field: 'OrdBilled',title: '计费'},
		{field: 'EndTime',title: '预停时间'},
		{field: 'BillType',title: '费别'},
		{field: 'ActiveQty',title: '实发数量'}, 
		{field: 'MaterialBarCode',title: '高值条码'}, 
		{field: 'ToInpatient',title: '医嘱来源'}, 
		{field: 'Pqty',title: '数量'},
		{field: 'PrescNo',title: '处方号'},
		{field: 'OrdSkinTestResult',title: '皮试结果'}
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
		{field: 'admDeptDesc',title: '就诊科室'},
		{field: 'orcatDesc',title: '医嘱大类'},
		{field: 'arcimDesc',title: '医嘱名称'}, 
		{field: 'phOrdQtyUnit',title: '总量'},
		{field: 'price',title: '单价'},
		{field: 'totalAmount',title: '总价'},
		{field: 'ctcpDesc',title: '开医嘱人',formatter:orderName},
		{field: 'reclocDesc',title: '接收科室'},
		{field: 'createDateTime',title: '开医嘱时间'},
		{field: 'sttDateTime',title: '要求执行时间'},
		{field: 'ordStatDesc',title: '医嘱状态'},
		{field: 'phcduDesc1',title: '疗程'},
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
	