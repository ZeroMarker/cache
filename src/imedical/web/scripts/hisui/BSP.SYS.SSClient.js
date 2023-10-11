var showDetails = function (clientId){
    websys_showModal({
	    title:'客户端禁用日志',
		width:700,height:500,
	    url:'websys.default.hisui.csp?WEBSYS.TCOMPONENT=BSP.SYS.SSClientInvalid&ClientId='+clientId
	});
    return;
}
$(function(){
	var applyIf= function(object, config) {
        var property;
        if (object) {
            for (property in config) {
                if (config.hasOwnProperty(property) && object[property] === undefined) {
	                object[property] = config[property];
	            }
            }
        }
        return object;
    };
	var tblSelector = "#tBSP_SYS_SSClient";
	if ($(tblSelector).length>0) {
		$(tblSelector).mgrid({
			className:"BSP.SYS.DTO.SSClient",
			queryName:"Find",
			codeField:'TMacAddr',
			//activeColName:'TDisableLogon',
			onColumnsLoad:function(cm){
				var defaultCm = [
					{field:"TID",hidden:true},
					{field:'TIPAddr',width:150,editor:{type:'text'}},
					{field:'TMacAddr',width:150,editor:{type:'text'}},
					{field:'TCompName',width:150,editor:{type:'text'}},
					{field:'TNote',width:150,editor:{type:'text'}},
					{field:'TDisableLogon',width:60,formatter:function(val,row,index){
								if (val==1) return "禁用";
								else {return "可用"}
							},editor:{type:'checkbox',options:{on:1,off:0}}
					},
					{field:'TDisableLogonDate',width:150,editor:{type:'dateboxq'}},
					{field:'TDisableLogonTime',width:150,editor:{type:'timeboxq'}}
				];
				for (var i=0;i<cm.length;i++){
					var defaultObj = $.hisui.getArrayItem(defaultCm,'field',cm[i].field)
					if (defaultObj){
						applyIf(cm[i],defaultObj);
					}
				}
				cm.push({field:'TDetails',width:60,formatter:function(val,row,index){
					return "<a href='#' onclick='showDetails("+row["TID"]+");return false;'>详细</a>"
				}});
			},
			editGrid:true,
			fit:false,
			height:500,
			key:"entt",
			fitColumns:true,
			autoSizeColumn:true,
			onClickRow:function(rowIndex,rowData){
			},
			onDblClickRow:function(rowIndex,rowData){
			},
			rownumbers:true,
			pagination:true,
			//pageSize:cminfo.pageSize==15?15:cminfo.pageSize,
			showPageList:false,
			singleSelect:true,
			url:$URL,
			onBeforeLoad:function(p){
				p.IPAddr = $("#IPAddr").val();
				p.MacAddr = $("#MacAddr").val();
				p.Note = $("#Note").val();
			},
			insOrUpdHandler:function(row){
				var param ={
					"dto.entt.id":row.TID,"dto.entt.MacAddr":row.TMacAddr,"dto.entt.IPAddr":row.TIPAddr,
					"dto.entt.CompName":row.TCompName,"dto.entt.DisableLogonTime":row.TDisableLogonTime,
					"dto.entt.Note":row.TNote,
					"dto.entt.DisableLogonDate":row.TDisableLogonDate,"dto.entt.DisableLogon":row.TDisableLogon
				};
				if (row.TID==""){
					if (!row.TMacAddr){
						$.messager.popover({msg:"Mac地址不能为空！",type:'info'});
						return false;
					}
					$.extend(param,this.insReq,{
						"dto.entt.id":""
					});
				}else{
					$.extend(param,this.updReq,{
						"dto.entity.id":row.TID
					});
				}
				$cm(param,defaultCallBack);
			},
			getNewRecord:function(){
				return {
					"dto.entt.id":"","dto.entt.MacAddr":"","dto.entt.IPAddr":"",
					"dto.entt.CompName":"","dto.entt.DisableLogonTime":"",
					"dto.entt.Note":"",
					"dto.entt.DisableLogonDate":"","dto.entt.DisableLogon":0
				};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "确定删除【"+row.TMacAddr+"】记录?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.entt.id":row.TID});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
		$(tblSelector).datagrid('options').view.onAfterRender = fixTGrid;
		$(window).on('resize',fixTGrid);
		$('#Find').click(function(){
			if (!$(this).linkbutton('options').disabled){
				$(tblSelector).datagrid('load');
			}
		});
	}
});