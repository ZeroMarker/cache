/**
 * ģ��:ҩ������
 * ��ģ��:�������,ҽ�������־ע���¼�
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
			/*  ��ˢ�µ�Ԫ��״̬
			if (newphoresult==""){
				newphoresult=" ";
			}
			var bgcolor="transparent";
			if (newphoresult!=" "){
				if (newphoresult=="ͨ��"){
					bgcolor=$(".dhcpha-record-passed").css("background-color");
				}else if (newphoresult=="�ܾ�"){
					bgcolor=$(".dhcpha-record-refused").css("background-color");
				}else if (newphoresult=="����"){
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
	$(_options.id).modal('show'); //ÿ�μ��ذ��¼�??ò�Ʋ���ѧ��
}
function InitOutMonitorLog(_options){
	
	orditm=_options.orditm;
	var columns=[
        {header:'�������',index:'auditdate',name:'auditdate',width:80},
        {header:'���ʱ��',index:'audittime',name:'audittime',width:60},
        {header:'�����',index:'audituser',name:'audituser',width:60},
        {header:'��˽��',index:'result',name:'result',width:60},       
        {header:'���ϸ�ʾֵ',index:'factor',name:'factor',width:60,hidden:true},
        {header:'ҩʦ����',index:'advice',name:'advice',width:60,hidden:true},
        {header:'ҽ����ע',index:'docadvice',name:'docadvice',width:60},  //ҽ�����߽���
        {header:'ҩʦ��ע',index:'phnote',name:'phnote',width:120},
        {header:'ҽ����ע',index:'docnote',name:'docnote',width:60,hidden:true},
        {header:'rowid',index:'rowid',name:'rowid',width:60,hidden:true}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=GetIPOrdAuditLog&style=jqGrid'+'&OrdItm='+orditm, //��ѯ��̨	
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
        {header:'���',index:'grpno',name:'grpno',width:40},
        {header:'ԭ���б�',index:'itmdesc',name:'itmdesc',width:250,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.THIS_URL+'?action=GetIPOrdAuditItmLog&style=jqGrid', //��ѯ��̨	
	    height: OutMonitorLogCanUseHeight()*0.5-40-5
	};
	$('#gird-monitorlogdetail').dhcphaJqGrid(jqOptions);
	$("#grid-monitorlog").setGridParam({
		postData:{
			'OrdItm':orditm
		}	
	}).trigger("reloadGrid");
	//����
	$("#btn-undo").unbind("click") 
	$("#btn-undo").on("click",function(){
		var grid_records = $("#grid-monitorlog").getGridParam('records');
		if (grid_records==0){
			dhcphaMsgBox.alert($g("��ǰ����������!"));
			return;
		}
		var firstrowdata = $("#grid-monitorlog").jqGrid("getRowData", 1); //��ȡ��һ������
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
					dhcphaMsgBox.alert($g("�����ظ�����!"));
				}else if (retvalue==-98){
					dhcphaMsgBox.alert($g("�������һ��,���ܳ���!"));
				}else if (retvalue==-16){
					dhcphaMsgBox.alert($g("����ҩ,���ܳ���!"));
				}else if (retvalue==-17){
					dhcphaMsgBox.alert($g("����ҩȷ��,���ܳ���!"));
				}else if (retvalue==-18){
					dhcphaMsgBox.alert($g("�����﷢ҩ,���ܳ���!"));
				}else if (retvalue==-19){
					dhcphaMsgBox.alert($g("��ǰΪ����״̬,���ܳ���!"));
				}else if (retvalue==-20){
					dhcphaMsgBox.alert($g("��סԺ��ҩ,���ܳ���!"));
				}else if (retvalue==-21){
					dhcphaMsgBox.alert($g("�Ѿܾ�(����),���ܳ���!"));
				}else{
					dhcphaMsgBox.alert($g("����ʧ��,�������")+":"+retjson[0].retinfo+"!");
				}0
			},  
			error:function(){}  
		})		
	})
}
//��ҳ��table���ø߶�
function OutMonitorLogCanUseHeight(){
	var bodyheight=$("#modal-monitorlog .modal-body").height();
	var resheight=20;
	var height1=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height2=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height3=parseFloat($("[class='panel-heading']").outerHeight());
	var tableheight=bodyheight-height1*2-height2*2-2*height3-resheight;
	return tableheight;
}
