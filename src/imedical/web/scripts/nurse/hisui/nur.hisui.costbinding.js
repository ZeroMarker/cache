$(function(){	
	InitPatOrd();
	reloadPatOrd();
})

var curSelRowIndex;
function InitPatOrd(){			
	var OrdColumns=[[ 
		{field:'StartDateTime',title:'ҽ����ʼʱ��',align:'center',width:160},
		{field:'oecprDesc',title:'ҽ������',align:'center',width:100},
		{field:'arcimDesc',title:'ҽ��',align:'left',width:400,
			formatter:function(value,row,index){
				value = '<span id=' + row["oeordId"] + ' onmouseover="ShowOrderDescDetail(this)">'+value+'</span>';
				if (row["xDateTime"] != "") {
					value = "<span style='color:red'" + "'>��ͣ��" + "</span>" + value;
				}
				/*
				if(row.attachFlag=="Y"){
					value +='<a class="delete-patOrd" onclick="deleteOrd(\''+row.oeordId+'\','+index+')">ɾ��</a>';	
				}*/
				return value;	
			
			}
		},
		{field:'operate',title:'����',align:'left',width:45,formatter:function(value,row,index){
			if(row.attachFlag !="Y") return ''
			return '<span class="delete-patOrd" onclick="deleteOrd(\''+row.oeordId+'\','+index+')"></span>';	
			
		}},
		{field:'groupChart',title:'�����',align:'center',width:60,styler:function(value,row,index){
 			return 'color:red;';
		}},
		{field:'doseQtyUnit',title:'����',align:'center',width:90},
		{field:'phcinDesc',title:'��ҩ;��',align:'center',width:90},
		{field:'phcfrCode',title:'Ƶ��',align:'center',width:90},
		{field:'phOrdQtyUnit',title:'����',align:'center',width:90},
		{field:'xDateTime',title:'ֹͣʱ��',align:'center',width:160},
		{field:'createDateTime',title:'��ҽ��ʱ��',align:'center',width:160},	
		{field:'oeordId',title:'ҽ��ID',align:'center',width:100}		
	]];
	$("#dg-patOrd").datagrid({
		fit : true,
		//singleSelect : true,
		frozenColumns:[[{field:'bedCode',title:'����',width:60},{field:'patName',title:'����',width:100}]],
		columns :OrdColumns,
		idField: 'oeordId',
		view: scrollview,
		pageSize:99999,
		ScrollView:1,
		onLoadSuccess: function () {
            $('.delete-patOrd').linkbutton({ plain: true, iconCls: 'icon-cancel'});
        },
		onClickRow:function(rowIndex,rowData){
			$("#dg-patOrd").datagrid("unselectAll");	
			$("#dg-patOrd").datagrid("selectRow",rowIndex);	
				
			var ordSeqID=rowData.ordSeqID;
			var rows=$("#dg-patOrd").datagrid("getRows");
			//var gridData=$("#dg-patOrd").datagrid("getData");
			//var rows=gridData.firstRows;
			if(ordSeqID==""){					
				var oeordId=rowData.oeordId;
				//var iframe=$("#nursesupplementord")[0].contentWindow;
				parent.UpdateClickHandler(); 
				// �л�����ҽ�� 
				parent.SwitchNewSelPat(rowData.episodeId,rowData.oeordId);
				/*
				if(curSelRowIndex!=="undefined" && curSelRowIndex!=rowIndex && rowData.attachFlag!="Y"){
					// ���浱ǰ��������
					var iframe=$("#nursesupplementord")[0].contentWindow;
					iframe.UpdateClickHandler(); 
					// �л�����ҽ�� 
					iframe.SwitchNewSelPat(rowData.episodeId,rowData.oeordId);
				}*/
				curSelRowIndex=rowIndex;
				rows.forEach(function(val,index){
					if(val.ordSeqID==oeordId){
						$("#dg-patOrd").datagrid("selectRow",index);
					}	
				})					
			}else{
				var masterIndex="",oeordId="",attachFlag="";
				rows.forEach(function(val,index){
					if(val.oeordId==ordSeqID || val.ordSeqID==ordSeqID){
						$("#dg-patOrd").datagrid("selectRow",index);
						if(val.oeordId==ordSeqID) masterIndex=index,attachFlag=val.attachFlag;
					}	
				})	
				//var iframe=$("#nursesupplementord")[0].contentWindow;
				parent.UpdateClickHandler();
				parent.SwitchNewSelPat(rowData.episodeId,ordSeqID);
				/*
				if(curSelRowIndex!=="undefined" && curSelRowIndex!=masterIndex && attachFlag!="Y"){
					var iframe=$("#nursesupplementord")[0].contentWindow;
					iframe.UpdateClickHandler();
					iframe.SwitchNewSelPat(rowData.episodeId,ordSeqID);
				}*/
			}
		}
	})
}
// ����ҽ����Ϣ
function reloadPatOrd(){
	var showStop = $("#showStop").checkbox("getValue");
	$.cm({
		ClassName:"Nur.NIS.Service.AttachOrder.Biz",
		QueryName:"FindAttachOrder",
		userId:session['LOGON.USERID'],
		timeStamp:timeStamp,
		showStop:showStop,
		rows:999999
	},function(data){
		$("#dg-patOrd").datagrid("loadData",data);
	})	
}
// ������ʾ��ҽ����ɾ��
function deleteOrd(oeordId,rowIndex){
	/*var errorArray = [];
	//����ִ��ҽ��������ִ�м�¼
	$.cm({
		ClassName:"Nur.NIS.Service.AttachOrder.Biz",
		MethodName:"CancelExecAll",
		oeoriId:oeordId,
		userId:session['LOGON.USERID'],
		locId:session['LOGON.CTLOCID']
	},function(data){
		if (data.errList) {
			data.errList.forEach(function(errObject) {
				errorArray.push(errObject.errInfo)
			});
		}
		if (errorArray.length === 0) {
			//var iframe=$("#nursesupplementord")[0].contentWindow;
			var ret = parent.UnuseOEOrder(oeordId); //ҽ��վ�ӿ�
			var rytneAry=ret.split("^")
			if (rytneAry[0]!=0){} // $.messager.alert("��ʾ", rytneAry[0]); //ҽ��վ�����Ѿ���ʾ
			else $("#dg-patOrd").datagrid("deleteRow",rowIndex);	
		} else {
			$.messager.alert("��ʾ", errorArray[0], 'info');
		}
	})*/
	var rtn=parent.MulOrdDealWithComDe(oeordId)
	var rytneAry=rtn.split("^")
	if (rytneAry[0]!=0){
	}else{
		$("#dg-patOrd").datagrid("deleteRow",rowIndex);
	}
	
}
function ShowOrderDescDetail(that){
		var index=$("#dg-patOrd").datagrid('getRowIndex',that.id);
		if(isNaN(index)) return;
		var row=$("#dg-patOrd").datagrid("getRows")[index];
		var strResult=row["tarList"] //"��֫�ۺ�ѵ��^1��^55^55"+String.fromCharCode(1)+"��֫�ۺ�ѵ��1^2��^66^132"+String.fromCharCode(1)+"ƽ�����ﷴ��ѵ��^1��^55^55"+String.fromCharCode(1)+"���˹���ѵ��������^1��^55^55";;
		
		if(!strResult){
			return;
		}
		if (HISUIStyleCode=="lite"){
			var content ='<table class="popover-table popover-table-lite">'
		}else{
			var content ='<table class="popover-table">'
		}
		
		
		//TODO ����$c(1)�����⣬��ΰ���$c(1)����
		var arr = strResult.split(String.fromCharCode(1));
		
		content= content + "<tr><td><span>"+$g('����')+"</span></td><td><span>"+$g('����')+"</span></td><td><span>"+$g('����(Ԫ)')+"</span></td><td><span>"+$g('�ܼ�(Ԫ)')+"</span></td></tr>"
		for(var i=0;i<arr.length;i++){
			var arrRow= arr[i].split("^");
			content= content + "<tr>" 
			+"<td><span>"+arrRow[0]+"</span></td>"+"<td><span>"+arrRow[1]+"</span></td>"+"<td class='td-right'><span>"+arrRow[2]+"</span></td>"+"<td class='td-right'><span>"+arrRow[3]+"</span></td>"
			+"</tr>"
		}
		
		content=content+"</table>"
 
  		MaxHeight='auto',placement="auto";
  		$(that).webuiPopover({
			title:$g('�շ���'),
			content:content,
			trigger:'hover',
			placement:placement,
			style:'table',
			height:MaxHeight
		});
		$(that).webuiPopover('show');
}