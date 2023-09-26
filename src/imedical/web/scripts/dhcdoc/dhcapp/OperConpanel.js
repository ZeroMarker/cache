var OperCon=(function(){
	var OperFlag = 1;       /// 手术显示状态
	function Init(){
		InitPageComponent();
	}
	/// 初始化界面控件内容
	function InitPageComponent(){
		/// 手术医生	
		$('#OperUser').combobox({
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'',
			//mode:'remote',
			blurValidValue:true,		
			onShowPanel:function(){		
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'';
				$("#OperUser").combobox('reload',unitUrl);
			}
		});
		/*if (OperFlag == 1){
			$("#OperCon").hide();   /// 隐藏手术信息
		}*/
		 var OperNameJson=tkMakeServerCall("web.DHCAppPisMasterQuery","GetOperName",EpisodeID);
		 $("#OperName").combogrid({
			panelWidth:680,
			//panelHeight:400,
	        mode:'remote',
	        idField:'OPSID',
	        textField:'OperDesc',
	        data: JSON.parse(OperNameJson),
	        columns:[[  
	            {field:'AppDateTime',title:'手术申请时间',width:150},  
	            {field:'OperDesc',title:'手术名称',width:90},  
	            {field:'AppCareProvDesc',title:'手术申请人',width:80},  
	            {field:'BodySiteDesc',title:'手术部位',width:80},  
	            {field:'OperDateTime',title:'手术时间',width:150},  
	            {field:'OPSID',title:'手术申请ID',width:80}  
	        ]],
	        pagination:true,
	        onSelect:function(index,rowData){
		        $("#OperPart").val(rowData.BodySiteDesc)
				$HUI.datetimebox("#OperTime").setValue(rowData.OperDateTime);
				$("#OperID").val(rowData.OPSID)
	            //console.log("index="+index+",rowData=",rowData);
	        },
	        onLoadSuccess:function(data){
		        if (data.rows.length==1) {
			        $('#OperName').combogrid('setValue', data.rows[0].OPSID);
			    }
		    }
	    });

	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();