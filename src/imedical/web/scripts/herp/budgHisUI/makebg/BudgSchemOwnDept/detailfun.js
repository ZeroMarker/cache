/**
 *按钮权限说明
 *新建状态：增加、保存、删除均可用
 *其他：均不可用
 *
 **/

var RowDelim = String.fromCharCode(1); //行数据间的分隔符, IsCheck, curSchemeName, syear
DetailFun = function (row,mainrow) {
	//console.log(JSON.stringify(row));
	
	var BFRowid = row.rowid;
	var AuDept = mainrow.AuDeptName;
	var curItemName = row.ItemName;
	var year = row.Year;
	var AuDeptDR = mainrow.AuDeptDR;
	var SchemId = mainrow.SchemId;
	var SchemAuditId = mainrow.rowid;
	var ItemCode = row.ItemCode;
	
	//初始化窗口
	var $Detailwin;
	$Detailwin = $('#DetailWin').window({
	    title: AuDept+'的'+curItemName+'项目预算情况',
	    width: 1100,
	    height: 580,
	    top: ($(window).height() - 580) * 0.5,
	    left: ($(window).width() - 1100) * 0.5,
	    //iconCls: 'icon-paper',
	    shadow: true,
	    modal: true,
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
           $("#LowerPartGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
	});
	$Detailwin.window('open');
    // 表单的垂直居中
    //xycenter($("Detailnorth"),$("Detailform"));
    
    //业务科室
    var DeptBoxObj = $HUI.combobox("#DeptBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid=hospid;
            param.userdr=userid;
            param.flag=6;
            param.year=year;
            param.audept=AuDeptDR;
        },
        onSelect:function(data){
	        //console.log(JSON.stringify(data));
	        var IsCurCheck = $('#IsCurCheckBox').checkbox('getValue'); 
	        if(IsCurCheck == true){
		        IsCurCheck=1;
		    }else{
			    IsCurCheck=0;
			}
		    DetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetailDept",
                userid :    userid, 
                schemAuditId :    SchemAuditId,
                audept :    AuDeptDR,
                Year :    year,
                itemcode :   ItemCode,
                deptdr : data.rowid,
                IsCurCheck : IsCurCheck
            }) 
     	}
    });
    //是否当前待审
    $("#IsCurCheckBox").checkbox({
        onCheckChange:function(event,value){
	        if(value == true){
	           value=1;
	        }else{
		       value=0;
		    }		   
			var IsCurXiaFang = $('#IsCurXiaFangBox').checkbox('getValue'); 
	        if(IsCurXiaFang == true){
		        IsCurXiaFang=1;
		    }else{
			    IsCurXiaFang=0;
			}
		    DetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetailDept",
                userid :    userid, 
                schemAuditId :    SchemAuditId,
                audept :    AuDeptDR,
                Year :    year,
                itemcode :   ItemCode,
                deptdr : $('#DeptBox').combobox('getValue'),
                IsCurCheck : value,
                IsCurXiaFang : IsCurXiaFang
            })
        }
    })
    
    //是否当前待下放
    $("#IsCurXiaFangBox").checkbox({
        onCheckChange:function(event,value){
            if(value == true){
	           value=1;
	        }else{
		       value=0;
		    }		   
			var IsCurCheck = $('#IsCurCheckBox').checkbox('getValue'); 
	        if(IsCurCheck == true){
		        IsCurCheck=1;
		    }else{
			    IsCurCheck=0;
			}
		    DetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetailDept",
                userid :    userid, 
                schemAuditId :    SchemAuditId,
                audept :    AuDeptDR,
                Year :    year,
                itemcode :   ItemCode,
                deptdr : $('#DeptBox').combobox('getValue'),
                IsCurCheck : IsCurCheck,
                IsCurXiaFang : value
            })
        }
    })
    //列配置对象
    EditColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'DeptName',
	                title:'业务科室',
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
					formatter: function (value, row, index) {
						if (value == 1) {
	                        return '<span class="grid-td-text">新建</span>';
	                    }else if(value == 2) {
	                        return '<span class="grid-td-text">提交</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">通过</span>';
	                    }else if(value == 4){
	                        return '<span class="grid-td-text">完成</span>';
	                    }else if(value == 5){
	                        return '<span class="grid-td-text">下放</span>';
	                    }else if(value == 6){
	                        return '<span class="grid-td-text">下放完成</span>';
	                    }else if(value == 7){
	                        return '<span class="grid-td-text">待下放</span>';
	                    }else {
	                        return '<span class="grid-td-text">'+value+'</span>';
	                    }
                    }
				},{
					field:'OneEstablishState',
					title:'一编状态',
					width:100, 
					formatter: function (value, row, index) {
                        if (value == 1) {
	                        return '<span class="grid-td-text">新建</span>';
	                    }else if(value == 2) {
	                        return '<span class="grid-td-text">提交</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">通过</span>';
	                    }else if(value == 4){
	                        return '<span class="grid-td-text">完成</span>';
	                    }else if(value == 5){
	                        return '<span class="grid-td-text">下放</span>';
	                    }else if(value == 6){
	                        return '<span class="grid-td-text">下放完成</span>';
	                    }else if(value == 7){
	                        return '<span class="grid-td-text">待下放</span>';
	                    }else {
	                        return '<span class="grid-td-text">'+value+'</span>';
	                    }
                    }
				},{
					field:'TwoEstablishState',
					title:'二编状态',
					width:100, 
					formatter: function (value, row, index) {
						if (value == 1) {
	                        return '<span class="grid-td-text">新建</span>';
	                    }else if(value == 2) {
	                        return '<span class="grid-td-text">提交</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">通过</span>';
	                    }else if(value == 4){
	                        return '<span class="grid-td-text">完成</span>';
	                    }else if(value == 5){
	                        return '<span class="grid-td-text">下放</span>';
	                    }else if(value == 6){
	                        return '<span class="grid-td-text">下放完成</span>';
	                    }else if(value == 7){
	                        return '<span class="grid-td-text">待下放</span>';
	                    }else {
	                        return '<span class="grid-td-text">'+value+'</span>';
	                    }
                    }
				},{
					field:'Goal',
					title:'绩效目标',
					width:70,
					align:'center', 
					formatter: function (value, row, index) {
						if (row != null) {
							return "<a href='#' class='grid-td-text'>目标</a>";
							
                        }
                    }
				},{
				    field:'IsGovernment',
				    title:'是否政府采购',
					align:'center',
				    width:95
				},{
	                field:'IsCurStep1',
	                title:'一上是否当前审批',
	                width:80,
	                hidden: true
                },{
	                field:'IsCurStep2',
	                title:'一下是否当前审批',
	                width:80,
	                hidden: true
                },{
	                field:'IsCurStep3',
	                title:'二上是否当前审批',
	                width:80,
	                hidden: true
                },{
	                field:'IsCurStep4',
	                title:'二下是否当前审批',
	                width:80,
	                hidden: true
                }

            ]];
            
     // 查询函数
    var DFindBtn= function()
    {
        var deptdr= $('#DeptBox').combobox('getValue'); 
        var IsCurCheck = $('#IsCurCheckBox').checkbox('getValue'); 
        
        if(IsCurCheck == true){
            IsCurCheck=1;
        }else{
            IsCurCheck=0;
        }
        var IsCurXiaFang = $('#IsCurXiaFangBox').checkbox('getValue'); 
	    if(IsCurXiaFang == true){
		        IsCurXiaFang=1;
		}else{
			    IsCurXiaFang=0;
		}
        DetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
                MethodName:"ListDetailDept",
                userid :    userid, 
                schemAuditId :    SchemAuditId,
                audept :    AuDeptDR,
                Year :    year,
                itemcode :   ItemCode,
                deptdr : deptdr,
                IsCurCheck : IsCurCheck,
                IsCurXiaFang:IsCurXiaFang
            })
    }
     
    //保存按钮
    var SaveBtn={
        id: 'SaveBtn',
        iconCls: 'icon-save',
        text: '保存',
        handler: function(){
            SaveBtn()
        }
    }
    
    
	//审核按钮
    var AuditBtn={
        id: 'AuditBtn',
        iconCls: 'icon-stamp',
        text: '审核',
        handler: function(){
            AuditBtn()
        }
    }
    
    //下放按钮
    var TransferToLowerBtn={
        id: 'TransferToLowerBtn',
        iconCls: 'icon-money-down',
        text: '下放',
        handler: function(){
            TransferToLowerBtn()
        }
    }
    
    //定义表格
    var DetailGrid = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemOwnDept",
            MethodName:"ListDetailDept",
            userid :    userid,
            schemAuditId :    SchemAuditId,
            audept :    AuDeptDR,
            Year :    year,
            itemcode :   ItemCode,
            deptdr : "",
            IsCurCheck : ""
        },
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        singleSelect: false, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        loadMsg:"正在加载，请稍等…",
        rownumbers:true,//行号 
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:EditColumns,
        onClickRow: function(index,row){
	        onClickRow($('#DetailGrid'),editIndex); //在用户点击一行的时候触发
	        var row = $('#DetailGrid').datagrid('getRows')[index];
	        var IsCurStep1 = row.IsCurStep1;
	        var IsCurStep2 = row.IsCurStep2;
	        var IsCurStep3 = row.IsCurStep3;
	        var IsCurStep4 = row.IsCurStep4;
	        
	        $('#SaveBtn').linkbutton("disable");
	        $('#TransferToLowerBtn').linkbutton("disable");
	        $('#AuditBtn').linkbutton("disable");
	        
	        if((IsCurStep1==1)||(IsCurStep2==1)||(IsCurStep3==1)||(IsCurStep4==1))
	        {
		        $('#SaveBtn').linkbutton("enable");
		        if((IsCurStep1==1)||(IsCurStep3==1))
		        {
			        $('#AuditBtn').linkbutton("enable"); 
			    }
			    if((IsCurStep2==1)||(IsCurStep4==1))
			    {
				    $('#TransferToLowerBtn').linkbutton("enable");
				}
		    }	
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
        	var rows = $('#DetailGrid').datagrid('getRows');
            var row = rows[index];
            if(field=='EstablishState'){
                schemastatefun(SchemAuditId, userid,SchemId,"","");
            }
            if(field=='OneEstablishState'){
                schemastatefun(SchemAuditId, userid,SchemId,1,ItemCode);
            }
            if(field=='TwoEstablishState'){
                schemastatefun(SchemAuditId, userid,SchemId,2,ItemCode);
            }
        },
        toolbar: '#tb'
    });

    //函数区
    var editIndex = undefined; //定义全局变量：当前编辑的行
    
    // 点击查询按钮 
    $("#DFindBn").click(DFindBtn);
    
        //审核
    var AuditBtn=  function(){
	    var rows = $('#DetailGrid').datagrid("getSelections");
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
        if(rows.length>0){
	        var IsCurCheck = $('#IsCurCheckBox').checkbox('getValue');
		    var BFRowids=""
		    for(var i=0; i<rows.length; i++){
			    var row=rows[i];
			    var BFRowid= row.rowid;
			    var IsCurStep1= row.IsCurStep1;
			    var IsCurStep3= row.IsCurStep3;
			    
			    //筛选审核当前待审的行
		        if((IsCurStep1==1)||(IsCurStep3==1)){
			        if(BFRowids==""){
				        BFRowids=BFRowid;
				    }else{
					    BFRowids=BFRowids+"^"+BFRowid; 
					}    
			    }
			    
			    //选中审核时，如果存在不是当前审核的行，给出提示信息
			    if(IsCurCheck == false){
				    if((IsCurStep1==0)&&(IsCurStep3==0)){
					    $.messager.popover({
						    msg:'只审核待审的行！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        }); 
			        }	
		        }		        
			}
			if(BFRowids==""){
				$.messager.popover({
						    msg:'选中的记录中没有需要当前人审核的记录！',timeout: 3000,type:'info',showType: 'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                } 
				}); 
				return;        
			}
			$.m({
				ClassName:'herp.budg.hisui.udata.uBudgSchemAuditDeptYear',
				MethodName:'UpdChkRecs',
				schemAuditDR:SchemAuditId, 
				BFRowids:BFRowids, 
				ChkSatte:1, 
				view:1, 
				UserID:userid
				},
				function(Data){
					if(Data==0){
						$.messager.popover({
						    msg:'操作成功！',timeout: 3000,type:'success',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        });
						$('#DetailGrid').datagrid("reload");
					}else{
						$.messager.popover({
						    msg:Data,timeout: 3000,type:'error',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        });
						$('#DetailGrid').datagrid("reload");
					}
				});   
		}else{
			$.messager.popover({
				msg:'请选择需要审核的行！',timeout: 3000,type:'info',showType: 'show',
				style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
				}
			});
			return;
		}
	}
    
	// 下放
	var TransferToLowerBtn= function(){
	    var rows = $('#DetailGrid').datagrid("getSelections");
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
        if(rows.length>0){
	        var IsCurCheck = $('#IsCurCheckBox').checkbox('getValue');
		    var BFRowids=""
		    for(var i=0; i<rows.length; i++){
			    var row=rows[i];
			    var BFRowid= row.rowid;
			    var IsCurStep1= row.IsCurStep1;
			    var IsCurStep3= row.IsCurStep3;
			    
			    //筛选下放当前待下放的行
		        if((IsCurStep1==1)||(IsCurStep3==1)){
			        if(BFRowids==""){
				        BFRowids=BFRowid;
				    }else{
					    BFRowids=BFRowids+"^"+BFRowid; 
					}    
			    }
			    
			    //选中行下放时，如果存在不是当前下放的行，给出提示信息
			    if(IsCurCheck == false){
				    if((IsCurStep1==0)&&(IsCurStep3==0)){
					    $.messager.popover({
						    msg:'只下放审核待审下放的行！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        }); 
			        }	
		        }		        
			}
			if(BFRowids==""){
				$.messager.popover({
						    msg:'选中的记录中没有需要当前人下放的记录！',timeout: 3000,type:'info',showType: 'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                } 
				}); 
				return;        
			}
			$.m({
				ClassName:'herp.budg.hisui.udata.uBudgSchemAuditDeptYear',
				MethodName:'TransferToLowers',
				schemAuditDR:SchemAuditId, 
				BFRowids:BFRowids, 
				ChkSatte:1, 
				view:1, 
				UserID:userid
				},
				function(Data){
					if(Data==0){
						$.messager.popover({
						    msg:'操作成功！',timeout: 3000,type:'success',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        });
						$('#DetailGrid').datagrid("reload");
					}else{
						$.messager.popover({
						    msg:Data,timeout: 3000,type:'error',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
					        }
				        });
						$('#DetailGrid').datagrid("reload");
					}
				});   
		}else{
			$.messager.popover({
				msg:'请选择需要下放的行！',timeout: 3000,type:'info',showType: 'show',
				style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:10
				}
			});
			return;
		}
	}
	
	// 保存
	var SaveBtn= function(){
	    
	}
   
}