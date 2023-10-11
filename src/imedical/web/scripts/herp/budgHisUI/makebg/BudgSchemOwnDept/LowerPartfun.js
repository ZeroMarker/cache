LowerPartFun = function(){ 

 
    //科目分类
    var DItemTypeObj = $HUI.combobox("#DItemType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        
        	//没有选中时，设置选中第一行
		    if(!$('#MainGrid').datagrid('getSelected')){
			   $('#MainGrid').datagrid('selectRow',0);   
		    }
		    var row = $('#MainGrid').datagrid('getSelected');
        	var IsLast = $('#IsLastBox').checkbox('getValue');
        	if(IsLast == true){
	        	IsLast=1;
	        }else{
		        IsLast=0;
		    }
            $('#LowerPartGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetail",
                hospid :    hospid,
                userid : userid,
                schemAuditId : row.rowid,
                itemTyCode :data.code,
                itemcode : $('#DItemBox').val(),
                isLast :IsLast  
            });
     	}
    });
    //是否末级
    $("#IsLastBox").checkbox({
        onCheckChange:function(event,value){
           if(value == true){
	           value=1;
	       }else{
		       value=0;
		   }		   
		   //没有选中时，设置选中第一行
		   if(!$('#MainGrid').datagrid('getSelected')){
			  $('#MainGrid').datagrid('selectRow',0);   
		   }
		   var row = $('#MainGrid').datagrid('getSelected');
		   schemAuditId=row.rowid;
		   
		   LowerPartGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetail",
                hospid :    hospid,
                userid : userid,
                schemAuditId : schemAuditId,
                itemTyCode :$('#DItemType').combobox('getValue'),
                itemcode : $('#DItemBox').val(),
                isLast :value  
            });  
        }
    })
    
    DetailColumns=[[  
                {
	                field:'ckbox',
	                checkbox:true
                },{
	                field:'rowid',
	                title:'ID',
	                idth:80,
	                hidden: true
                },{
	                field:'Year',
	                title:'年度',
	                width:80,
	                hidden: true
                },{
	                field:'ItemCode',
	                title:'科目编码',
	                width:100
                },{
	                field:'ItemName',
	                title:'科目名称',
	                width:200
	            },{
					field:'PlanValue',
					title:'本年预算',
					width:120,
					align:'right', 
					formatter: function (value, row, index) {
						if (row != null) {
							var val=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
							return "<a href='#' class='grid-td-text'>"+val+"</a>";
							//return "<a href='#' class='grid-td-text' onclick=DetailFun("+row+"\)>"+val+"</a>";
                        }
                    }
				},{
					field:'OneUpVaule',
					title:'一上预算',
					width:120,
					align:'right', 
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'OneDownVaule',
					title:'一下预算',
					width:120,
					align:'right', 
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'TwoUpVaule',
					title:'二上预算',
					width:120,
					align:'right', 
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
				},{
					field:'TwoDownVaule',
					title:'二下预算',
					width:120,
					align:'right', 
					formatter: function (value, row, index) {
						if (row != null) {
							return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                        }
                    }
                },{
					field:'EstablishState',
					title:'编制状态',
					width:100,
	                hidden: true, 
					formatter: function (value, row, index) {
						if (row != null) {
							return "<a href='#' class='grid-td-text'>"+value+"</a>";
							
                        }
                    }
				},{
					field:'OneEstablishState',
					title:'一编状态',
					width:100,
	                hidden: true, 
					formatter: function (value, row, index) {
						if (row != null) {
							return "<a href='#' class='grid-td-text'>"+value+"</a>";
							
                        }
                    }
				},{
					field:'TwoEstablishState',
					title:'二编状态',
					width:100,
	                hidden: true, 
					formatter: function (value, row, index) {
						if (row != null) {
							return "<a href='#' class='grid-td-text'>"+value+"</a>";
							
                        }
                    }
				}
            ]];
    var LowerPartGridObj = $HUI.datagrid("#LowerPartGrid",{
        url:$URL,
        delay:200,
        fitColumns: false,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        singleSelect: true, //只允许选中一行
        fit:true,
        columns:DetailColumns,
        onClickCell: function(index,field,value){
            if(field=='PlanValue'){
	            $('#LowerPartGrid').datagrid('selectRow',index);
	            var row = $('#LowerPartGrid').datagrid('getSelected');
	            if(!$('#MainGrid').datagrid('getSelected')){
		            $('#MainGrid').datagrid('selectRecord',row.schemAuditId);
		        }
		   var mainrow = $('#MainGrid').datagrid('getSelected');
		   
               DetailFun(row,mainrow); 
               //schemastatefun('', userid, '');
            }
        },
        toolbar: '#ltb'    
    });    
    // 查询函数
    var lFindBn= function()
    {
        var IsLast = $('#IsLastBox').checkbox('getValue');
           if(IsLast == true){
	           IsLast=1;
	       }else{
		       IsLast=0;
		   }
		   //alert("IsLast");		   
		   //没有选中时，设置选中第一行
		   if(!$('#MainGrid').datagrid('getSelected')){
			  $('#MainGrid').datagrid('selectRow',0);   
		   }
		   var row = $('#MainGrid').datagrid('getSelected');
		   schemAuditId=row.rowid;
		   
		   LowerPartGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetail",
                hospid :    hospid,
                userid : userid,
                schemAuditId : schemAuditId,
                itemTyCode :$('#DItemType').combobox('getValue'),
                itemcode : $('#DItemBox').val(),
                isLast :IsLast  
            });  
        
    }

    // 点击查询按钮 
    $("#lFindBn").click(lFindBn);
    
}