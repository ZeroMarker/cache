/**
 * 模块:药房公共
 * 子模块:处方审核,医嘱审核日志注册事件
 * createdate:2016-08-16
 * creator:yunhaibao
 */
/**
 * @_options {id,orditm,fromgrid,fromgridselid} 
 */
function InitOutMonitorLogBody(_options){
	$(_options.id).off().on( 'hidden', 'hidden.bs.modal');  
	$(_options.id).on('show.bs.modal', function () {
		$("#modal-monitorlog .modal-dialog").width($(window).width()*0.75)
		$("#modal-monitorlog .modal-body").height($(window).height()*0.75)
	});
	var monitorlogtimes=0;
	$(_options.id).on('shown.bs.modal', function () {
		monitorlogtimes=monitorlogtimes+1;
		if (monitorlogtimes<2){
			InitOutMonitorLog(_options);
		}
	});
	$(_options.id).on('hidden.bs.modal', function () {
		var fromgrid=_options.fromgrid;
		var fromgridselid=_options.fromgridselid;
		if (fromgrid=="#grid-presc"){
			var selectdata=$(fromgrid).jqGrid('getRowData',fromgridselid);
			var prescno=selectdata.prescno;
			var phoresult=selectdata.result;
			var newphoresult=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","GetCurPhoResultByPresc",prescno);
			if(newphoresult!=phoresult){
				QueryGridPresc();
			}
			/*  仅刷新单元格状态
			if (newphoresult==""){
				newphoresult=" ";
			}
			var bgcolor="transparent";
			if (newphoresult!=" "){
				if (newphoresult=="通过"){
					bgcolor=$(".dhcpha-record-passed").css("background-color");
				}else if (newphoresult=="拒绝"){
					bgcolor=$(".dhcpha-record-refused").css("background-color");
				}else if (newphoresult=="申诉"){
					bgcolor=$(".dhcpha-record-appeal").css("background-color");
				}
			}
			var cssprop = {  
				background: bgcolor,
				color:'black'
			};
			$(".dhcpha-record-disped").css("background-color");
			$(fromgrid).setCell(fromgridselid,'result',newphoresult,cssprop);
			*/
		}else if (fromgrid=="#grid-cypresc"){
			var selectdata=$(fromgrid).jqGrid('getRowData',fromgridselid);
			var prescno=selectdata.TPrescNo;
			var phoresult=selectdata.TAuditResult;
			var newphoresult=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","GetCurPhoResultByPresc",prescno);
			if(newphoresult!=phoresult){
				QueryGridPrescAudit();
			}
		}else if (fromgrid=="#grid-orderdetail"){
			var selectdata=$(fromgrid).jqGrid('getRowData',fromgridselid);
			var orditem=selectdata.orditem;
			var phoresult=selectdata.result;
			var newphoresult=tkMakeServerCall("web.DHCSTCNTSIPMONITOR","GetCurPhoResultByOeori",orditem);
			if(newphoresult!=phoresult){
				QueryIPMonitorOrdDetail();
			}		
		}
	});
	$(_options.id).modal('show'); //每次加载绑定事件??貌似不科学啊
}
function InitOutMonitorLog(_options){
	
	orditm=_options.orditm;
	var columns=[
        {header:'审核日期',index:'auditdate',name:'auditdate',width:80},
        {header:'审核时间',index:'audittime',name:'audittime',width:60},
        {header:'审核人',index:'audituser',name:'audituser',width:60},
        {header:'审核结果',index:'result',name:'result',width:60},       
        {header:'不合格警示值',index:'factor',name:'factor',width:60,hidden:true},
        {header:'药师建议',index:'advice',name:'advice',width:60,hidden:true},
        {header:'医生备注',index:'docadvice',name:'docadvice',width:60},  //医生申诉建议
        {header:'药师备注',index:'phnote',name:'phnote',width:120},
        {header:'医生备注',index:'docnote',name:'docnote',width:60,hidden:true},
        {header:'rowid',index:'rowid',name:'rowid',width:60,hidden:true}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=GetIPOrdAuditLog&style=jqGrid'+'&OrdItm='+orditm, //查询后台	
	    height:OutMonitorLogCanUseHeight()*0.5-40-5, //($("#modal-monitorlog .modal-body").height()-20)*0.3,
	    onSelectRow:function(id,status){
			var id = $(this).jqGrid('getGridParam', 'selrow');
			var selrowdata = $(this).jqGrid('getRowData', id);
		    var monitorid=selrowdata.rowid;
			$("#gird-monitorlogdetail").setGridParam({
				postData:{
					'PHOMDR':monitorid
				}	
			}).trigger("reloadGrid");
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#gird-monitorlogdetail").setGridParam({
					postData:{
						'PHOMDR':""
					}	
				}).trigger("reloadGrid");
			}else{
				setTimeout(function () { 
			       $("#grid-monitorlog").setSelection(1);
			    }, 300);
				
			}
		}
	};
	$('#grid-monitorlog').dhcphaJqGrid(jqOptions);
	
	var columns=[
        {header:'组号',index:'grpno',name:'grpno',width:40},
        {header:'原因列表',index:'itmdesc',name:'itmdesc',width:250,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=GetIPOrdAuditItmLog&style=jqGrid', //查询后台	
	    height: OutMonitorLogCanUseHeight()*0.5-40-5
	};
	$('#gird-monitorlogdetail').dhcphaJqGrid(jqOptions);
	$("#grid-monitorlog").setGridParam({
		postData:{
			'OrdItm':orditm
		}	
	}).trigger("reloadGrid");
	//撤消
	$("#btn-undo").unbind("click") 
	$("#btn-undo").on("click",function(){
		var grid_records = $("#grid-monitorlog").getGridParam('records');
		if (grid_records==0){
			dhcphaMsgBox.alert($g("当前界面无数据!"));
			return;
		}
		var firstrowdata = $("#grid-monitorlog").jqGrid("getRowData", 1); //获取第一行数据
		var rowid=firstrowdata.rowid;
		var input=session['LOGON.USERID']+"^"+rowid;
		$.ajax({
			url:DHCPHA_CONSTANT.URL.THIS_URL + '?action=CancelPhOrdAudit&Input=' + encodeURI(input),
			type:'post',   
			success:function(data){ 
				var retjson=JSON.parse("["+data+"]");
				var retvalue=retjson[0].retvalue;
				if (retvalue==0){
					$("#grid-monitorlog").setGridParam({
						postData:{
							'OrdItm':orditm
						}	
					}).trigger("reloadGrid");
				}else if (retvalue==-99){
					dhcphaMsgBox.alert($g("不能重复撤消!"));
				}else if (retvalue==-98){
					dhcphaMsgBox.alert($g("不是最后一次,不能撤消!"));
				}else if (retvalue==-16){
					dhcphaMsgBox.alert($g("已配药,不能撤消!"));
				}else if (retvalue==-17){
					dhcphaMsgBox.alert($g("已配药确认,不能撤消!"));
				}else if (retvalue==-18){
					dhcphaMsgBox.alert($g("已门诊发药,不能撤消!"));
				}else if (retvalue==-19){
					dhcphaMsgBox.alert($g("当前为申诉状态,不能撤消!"));
				}else if (retvalue==-20){
					dhcphaMsgBox.alert($g("已住院发药,不能撤消!"));
				}else if (retvalue==-21){
					dhcphaMsgBox.alert($g("已拒绝(接受),不能撤消!"));
				}else{
					dhcphaMsgBox.alert($g("撤消失败,错误代码")+":"+retjson[0].retinfo+"!");
				}0
			},  
			error:function(){}  
		})		
	})
}
//本页面table可用高度
function OutMonitorLogCanUseHeight(){
	var bodyheight=$("#modal-monitorlog .modal-body").height();
	var resheight=20;
	var height1=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height2=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height3=parseFloat($("[class='panel-heading']").outerHeight());
	var tableheight=bodyheight-height1*2-height2*2-2*height3-resheight;
	return tableheight;
}
