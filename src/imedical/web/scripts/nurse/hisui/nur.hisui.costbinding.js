$(function(){	
	InitPatOrd();
	reloadPatOrd();
})

var curSelRowIndex;
function InitPatOrd(){			
	var OrdColumns=[[ 
		{field:'StartDateTime',title:'医嘱开始时间',align:'center',width:160},
		{field:'oecprDesc',title:'医嘱类型',align:'center',width:100},
		{field:'arcimDesc',title:'医嘱',align:'left',width:400,
			formatter:function(value,row,index){
				value = '<span id=' + row["oeordId"] + ' onmouseover="ShowOrderDescDetail(this)">'+value+'</span>';
				if (row["xDateTime"] != "") {
					value = "<span style='color:red'" + "'>【停】" + "</span>" + value;
				}
				/*
				if(row.attachFlag=="Y"){
					value +='<a class="delete-patOrd" onclick="deleteOrd(\''+row.oeordId+'\','+index+')">删除</a>';	
				}*/
				return value;	
			
			}
		},
		{field:'operate',title:'操作',align:'left',width:45,formatter:function(value,row,index){
			if(row.attachFlag !="Y") return ''
			return '<span class="delete-patOrd" onclick="deleteOrd(\''+row.oeordId+'\','+index+')"></span>';	
			
		}},
		{field:'groupChart',title:'组符号',align:'center',width:60,styler:function(value,row,index){
 			return 'color:red;';
		}},
		{field:'doseQtyUnit',title:'剂量',align:'center',width:90},
		{field:'phcinDesc',title:'用药途径',align:'center',width:90},
		{field:'phcfrCode',title:'频率',align:'center',width:90},
		{field:'phOrdQtyUnit',title:'总量',align:'center',width:90},
		{field:'xDateTime',title:'停止时间',align:'center',width:160},
		{field:'createDateTime',title:'开医嘱时间',align:'center',width:160},	
		{field:'oeordId',title:'医嘱ID',align:'center',width:100}		
	]];
	$("#dg-patOrd").datagrid({
		fit : true,
		//singleSelect : true,
		frozenColumns:[[{field:'bedCode',title:'床号',width:60},{field:'patName',title:'姓名',width:100}]],
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
				// 切换病人医嘱 
				parent.SwitchNewSelPat(rowData.episodeId,rowData.oeordId);
				/*
				if(curSelRowIndex!=="undefined" && curSelRowIndex!=rowIndex && rowData.attachFlag!="Y"){
					// 保存当前界面数据
					var iframe=$("#nursesupplementord")[0].contentWindow;
					iframe.UpdateClickHandler(); 
					// 切换病人医嘱 
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
// 加载医嘱信息
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
// 按天显示的医嘱的删除
function deleteOrd(oeordId,rowIndex){
	/*var errorArray = [];
	//撤销执行医嘱的所有执行记录
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
			var ret = parent.UnuseOEOrder(oeordId); //医生站接口
			var rytneAry=ret.split("^")
			if (rytneAry[0]!=0){} // $.messager.alert("提示", rytneAry[0]); //医生站代码已经提示
			else $("#dg-patOrd").datagrid("deleteRow",rowIndex);	
		} else {
			$.messager.alert("提示", errorArray[0], 'info');
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
		var strResult=row["tarList"] //"上肢综合训练^1次^55^55"+String.fromCharCode(1)+"下肢综合训练1^2次^66^132"+String.fromCharCode(1)+"平衡生物反馈训练^1次^55^55"+String.fromCharCode(1)+"烧伤功能训练床治疗^1次^55^55";;
		
		if(!strResult){
			return;
		}
		if (HISUIStyleCode=="lite"){
			var content ='<table class="popover-table popover-table-lite">'
		}else{
			var content ='<table class="popover-table">'
		}
		
		
		//TODO 还是$c(1)的问题，如何按照$c(1)分组
		var arr = strResult.split(String.fromCharCode(1));
		
		content= content + "<tr><td><span>"+$g('名称')+"</span></td><td><span>"+$g('数量')+"</span></td><td><span>"+$g('单价(元)')+"</span></td><td><span>"+$g('总价(元)')+"</span></td></tr>"
		for(var i=0;i<arr.length;i++){
			var arrRow= arr[i].split("^");
			content= content + "<tr>" 
			+"<td><span>"+arrRow[0]+"</span></td>"+"<td><span>"+arrRow[1]+"</span></td>"+"<td class='td-right'><span>"+arrRow[2]+"</span></td>"+"<td class='td-right'><span>"+arrRow[3]+"</span></td>"
			+"</tr>"
		}
		
		content=content+"</table>"
 
  		MaxHeight='auto',placement="auto";
  		$(that).webuiPopover({
			title:$g('收费项'),
			content:content,
			trigger:'hover',
			placement:placement,
			style:'table',
			height:MaxHeight
		});
		$(that).webuiPopover('show');
}