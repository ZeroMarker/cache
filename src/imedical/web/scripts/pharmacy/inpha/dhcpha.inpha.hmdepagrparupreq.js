/*
ģ��:		סԺ��ҩ��
��ģ��:		סԺ��ҩ��-����Э�����޸�
Creator:	hulihua
CreateDate:	2018-03-27
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* ��ʼ����� start*/
    InitDepAgrpList();
    InitDepAgrpDetList();	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
})

window.onload=function(){
	setTimeout("QueryArgParReq()",500);
}

//��ʼ��δ��ҩ���뵥�б�
function InitDepAgrpList(){
	//����columns
	var columns=[
		{header:'TPhaAprId',index:'TPhaAprId',name:'TPhaAprId',width:30,hidden:true},
		{header:'���뵥��',index:'TAgrReqNo',name:'TAgrReqNo',width:80},
		{header:'��������',index:'TAgrReqDate',name:'TAgrReqDate',width:130},
		{header:'������',index:'TAgrReqUser',name:'TAgrReqUser',width:60},
		{header:'��Դ����',index:'TAgrFromWard',name:'TAgrFromWard',width:120}
    ];
         
    var jqOptions={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=GetAgrParReqList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)*0.4,
		onSelectRow:function(id,status){
			SelectQueryAgrReqDetail();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-depagrpreq").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	} 
   //����datagrid	
   $('#grid-depagrpreq').dhcphaJqGrid(jqOptions);
}

//��ʼ��δ��ҩ���뵥��ϸ��Ϣ�б�
function InitDepAgrpDetList(){
	//����columns
	var columns=[
		{header:'TPhaApriId',index:'TPhaApriId',name:'TPhaApriId',width:30,hidden:true},
		{header:'Э��������',index:'TArcimDesc',name:'TArcimDesc',width:120,align:'left'},
		{header:'�ۻ�����',index:'TAccQty',name:'TAccQty',width:30},
		{header:'��������',index:'TReqQty',name:'TReqQty',width:30,
			editable:true,
			cellattr:addTextCellAttr,
			inputlimit:{
	           	number:true,
	        	negative:false
	        }
		},
		{header:'��λ',index:'TDispUom',name:'TDispUom',width:30},
		{header:'�޸�����',index:'TUpReqDate',name:'TUpReqDate',width:80},
		{header:'�޸���',index:'TUpReqUser',name:'TUpReqUser',width:60}
    ];        
    var dataGridOption={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMDepartDisp.AgrPartyDispReq&MethodName=GetAgrParReqDetList',
		height:GridCanUseHeight(1)*0.6,
		multiselect: false,
		shrinkToFit:false,
		rownumbers: true,
		autoScroll:true,  
		onSelectRow:function(id,status){
			if ((JqGridCanEdit==false)&&(LastEditSel!="")&&(LastEditSel!=id)){
			    $("#grid-depagrpreqdetail").jqGrid('setSelection',LastEditSel);
			    return
			}
			if ((LastEditSel!="")&&(LastEditSel!=id)){
				$(this).jqGrid('saveRow', LastEditSel);
			}			
			$(this).jqGrid("editRow", id,{oneditfunc:function(){
				$editinput = $(event.target).find("input");
				$editinput.focus(); 
				$editinput.select();
				$("#"+id+"_TReqQty").on("focusout || mouseout",function(){	
					var iddata=$('#grid-depagrpreqdetail').jqGrid('getRowData',id);
					var dspqty=iddata.TAccQty;								
					if (parseFloat(this.value*1000)>parseFloat(dspqty*1000)) {
						dhcphaMsgBox.message("��"+id+"�������������ڻ�������!")
						$("#grid-depagrpreqdetail").jqGrid('restoreRow',id);
						JqGridCanEdit=false
						return false
					}else{
						var phaapriid=iddata.TPhaApriId;
						var ResultCode=tkMakeServerCall("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","UpReqDetData",phaapriid,this.value,gUserID);
						if(ResultCode!=0){
							if(ResultCode=="-1"){
								dhcphaMsgBox.alert("�޸���������ʧ��,δѡ����ϸ��Ϣ��");
							}else if(ResultCode=="-2"){
								dhcphaMsgBox.alert("�޸���������ʧ��,δѡ����ϸ��Ϣ��");
							}else{
								dhcphaMsgBox.alert("�޸���������ʧ��,�����뵥�Ѿ��Ƿ�����״̬��");
							}
							$("#grid-depagrpreqdetail").jqGrid('restoreRow',id);
							JqGridCanEdit=false;
							return false;
						}else{
							JqGridCanEdit=true;
							return true;
						}
					}
				});
			}});
			LastEditSel=id;
		}
	} 
   //����datagrid	
   $('#grid-depagrpreqdetail').dhcphaJqGrid(dataGridOption);
   PhaGridFocusOut('grid-depagrpreqdetail');
} 

///��ѯδ��ҩ�����뵥��Ϣ
function QueryArgParReq()
{
	var phaloc="96";
	var wardloc=gLocId;
	if (wardloc==null){wardloc=""}
	var aprstatus="R";
	var params=phaloc+tmpSplit+wardloc+tmpSplit+aprstatus;
	$("#grid-depagrpreq").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///��ѯ��ϸ
function SelectQueryAgrReqDetail(){
	var selectid = $("#grid-depagrpreq").jqGrid('getGridParam', 'selrow');
	if(selectid==null){
		return;	
	}
	var selrowdata = $("#grid-depagrpreq").jqGrid('getRowData', selectid);
	var phaaprid=selrowdata.TPhaAprId;
	if((phaaprid==null)||(phaaprid=="")){
		return;
	}
	var params=phaaprid;
	$("#grid-depagrpreqdetail").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//�༭����������֮����꽻���뿪���浱ǰ����
function PhaGridFocusOut(gridid){
	$("#"+gridid).focusout(function(e){
		if (e.relatedTarget) {
	        var $related = $("#"+gridid).find(e.relatedTarget);
	        if ($related.length <= 0 && LastEditSel!="") {
	            $("#"+gridid).jqGrid('saveRow', LastEditSel);
	        }
	    }
	})
}

//���
function ClearConditions(){
	$('#grid-depagrpreq').clearJqGrid();
	$('#grid-depagrpreqdetail').clearJqGrid();
}
