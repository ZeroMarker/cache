
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBConfigAdmin&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBConfigAdmin";
var UPDATE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBConfig&pClassMethod=SaveData";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBConfigAdmin&pClassMethod=DeleteData";
var init=function()
{
	var windowHight = document.documentElement.clientHeight;        //可获取到高度
	var windowWidth = document.documentElement.clientWidth;
	$('#btnUpdate').linkbutton({text:'修改配置'});
	//诊断来源下拉框
    $("#ConfigValue").combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array",
        valueField:'id',
        textField:'MKBSTBDesc',
        panelWidth:257 
    });
	var columns =[[
	        {field:'ConfigDesc',title:'配置项描述',sortable:true,width:100,styler : function(value, row, index) {
					return 'border:0;';
				},align:'right'
			},
	        {field:'ConfigValue',title:'配置项值',sortable:true,width:100,styler : function(value, row, index) {
					return 'border:0;';
				},align:'left',
				formatter: function(value,row,index){
					value=tkMakeServerCall("web.DHCBL.MKB.MKBConfig","getSingleResource",row.ConfigCode,value);
					var btn = '<a class="contrast" href="#"  onclick="SetDeptJoinUser('+index+')" style="border:0px;cursor:pointer">用户科室配置</a>';  
					if ((row.ConfigDesc=="开启用户科室配置")&&(value=="是"))
					{
						return value+"  "+btn
					}
					else
					{
						return value
					}
					
					
        		}
			},
	        {field:'ID',title:'rowid',sortable:true,width:100,hidden:true}
    	]];
    var mygrid = $HUI.datagrid("#mygrid",{
	       	url:$URL,
	        queryParams:{
	            ClassName:"web.DHCBL.MKB.MKBConfig",          /////////***************
	            QueryName:"GetList"
	        },
	        columns: columns,  //列信息
	        singleSelect:true,
	        remoteSort:false,
	        idField:'ID',
	        showHeader:false,   
	        border:false,
	        fixRowNumber:true,
	        fitColumns:true //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
    });

	SetDeptJoinUser=function(index){
		
		$("#SetLocUserWin").show();
		var SetLocUserWin = $HUI.dialog("#SetLocUserWin",{
			iconCls:'icon-w-setting',
			width: windowWidth-50,    
        	height: windowHight-20, 
			resizable:true,
			title:'CDSS用户科室配置',
			modal:true
		});
		var loc_grid=$HUI.datagrid('#loc_grid',{  
		    url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBConfig",
				QueryName:"GetLocList"
			},
			columns:[[	
					{field:'ck',checkbox:true},
					{field:'DeptID',title:'ID',width:40,sortable:true,hidden:true},  //,hidden:true
					{field:'DeptCode',title:'科室代码',width:80},
					{field:'DeptName',title:'科室描述',width:150},
					{field:'EnableFlag',title:'是否有权限',width:80,align:'center',formatter:ReturnFlagIcon
					}
					]],	
			width: (windowWidth-50)*0.6, 	
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        pageSize:1000,
	        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	        singleSelect:false,
	        remoteSort:false,
			//idField:'DeptID',
			rownumbers:true,    //设置为 true，则显示带有行号的列。
	        fixRowNumber:true,
	        fitColumns:true,
	        onClickRow:function(index, row)
	        {
	            if (row.EnableFlag=="0")
	            {
	            	$('#btnUserAble').linkbutton('disable');
	            	$('#btnUserDisable').linkbutton('disable');
	            		            	
	            }
	            else
	            {
	            	$('#btnUserAble').linkbutton('enable');
	            	$('#btnUserDisable').linkbutton('enable');
	            }
	           /* $('#user_grid').datagrid('load', {
		            ClassName: "web.DHCBL.MKB.MKBConfig", ///调用Query时
		            QueryName: "GetUserList",
		            'deptdr':row.DeptID
		        })
	            $('#UserSearch').searchbox('setValue',"")
	            $('#UserEnableSearch').combobox("setValue","")
	            //$('#user_grid').datagrid('reload')
	            $('#user_grid').datagrid('clearSelections')*/
	            IsShowImg(row)
	            DeptJoinUser_Check(row.DeptID)
	            
	            
	        },
	        onLoadSuccess:function(data){
	        	IsShowImg("")
	        }

		});
		// 勾选
	    DeptJoinUser_Check=function(LocID)
	    {
	        //var record=$('#loc_grid').datagrid('getSelected')        
	        var OldUserStr=tkMakeServerCall("web.CDSS.CMKB.DeptUserAuthorize","GetUsersByLocid",LocID);
        	oldUser=[]
	        if (OldUserStr!="")
	        {
	            var userid=OldUserStr.split("^")
	            
	            for (var m=0;m<userid.length;m++)
	            {     
	            	if (userid[m]=="") 
	            	{
	            		continue
	            	}          	                
	                oldUser.push(userid[m]);
	                var tindex=$("#user_grid").datagrid("getRowIndex",userid[m])
	                if (tindex<0){
	                	continue
	                }
	                $("#user_grid").datagrid("selectRow", tindex);
	                    
	            }
	        }

	    }
		var user_grid=$HUI.datagrid('#user_grid',{  
		    url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBConfig",
				QueryName:"GetUserList"
			},
			columns:[[	
					{field:'ck',checkbox:true},
					{field:'UserID',title:'ID',width:40,sortable:true,hidden:true},  //,hidden:true
					{field:'UserCode',title:'用户代码',width:80},
					{field:'UserDesc',title:'用户描述',width:100},
					{field:'EnableFlag',title:'是否有权限',width:80,align:'center',formatter:ReturnFlagIcon
					}
					]],		
			width: (windowWidth-50)*0.4, 
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        pageSize:1000,
	        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	        singleSelect:false,
	        remoteSort:false,
			//idField:'ID',
			rownumbers:true,    //设置为 true，则显示带有行号的列。
	        fixRowNumber:true,
	        fitColumns:true

		});
		ClearUserList=function ()
		{
			var record=$('#loc_grid').datagrid('getSelected') 
			if (record)
			{
				var LocID=record.DeptID 
				$('#UserSearch').searchbox('setValue',"")
	            $('#UserEnableSearch').combobox("setValue","")
				$('#user_grid').datagrid('load', {
			            ClassName: "web.DHCBL.MKB.MKBConfig", ///调用Query时
			            QueryName: "GetUserList",
			            'deptdr':LocID
		        })
	            
	            $('#user_grid').datagrid('clearSelections')
	            $('#user_grid').datagrid('clearChecked')
	            DeptJoinUser_Check(LocID) 
			}
				
            
		}

		//是否显示图片
		 IsShowImg=function(rowData){
		 	if (rowData=="")
		 	{
		 		
				//清空中间属性列表，变为图片，改变标题
				if (document.getElementById('user_grid').style.display=="")   //如果是mygrid加载的状态
				{	
					$('#UserSearch').searchbox('setValue',"")
            		$('#UserEnableSearch').combobox("setValue","")
					$('#user_grid').datagrid('loadData', { total: 0, rows: [] }); 
					document.getElementById('user_grid').style.display='none';  //隐藏mygrid
					$("#div-img").show();  //展示初始图片			
				}
		 	}
		 	else
		 	{
		 		document.getElementById('user_grid').style.display='';  //显示user_grid
				$("#div-img").hide();
				ClearUserList();
															
			 }
		 
		 }

		var oldUser=[]
		var newUser=[]
		//两个数组的差集 // 差集 a - b
	    function array_difference(a, b) { 
	        //clone = a
	        var clone = a.slice(0);
	        for(var i = 0; i < b.length; i ++) {
	            var temp = b[i];
	            for(var j = 0; j < clone.length; j ++) {
	                if(temp === clone[j]) {
	                    //remove clone[j]
	                    clone.splice(j,1);
	                }
	            }
	        }
	        return array_remove_repeat(clone);
	    }
	    //去重
	    function array_remove_repeat(a) { 
	        var r = [];
	        for(var i = 0; i < a.length; i ++) {
	            var flag = true;
	            var temp = a[i];
	            for(var j = 0; j < r.length; j ++) {
	                if(temp === r[j]) {
	                    flag = false;
	                    break;
	                }
	            }
	            if(flag) {
	                r.push(temp);
	            }
	        }
	        return r;
	    }
		 //用户权限添加
	    $("#btnUserAble").click(function(e) {
	    	DoDeptJoinUser_Save(0)
	    })
	     //用户权限删除
	    $("#btnUserDisable").click(function(e) {
	        DoDeptJoinUser_Save(1)
	    })
	    DoDeptJoinUser_Save=function(backflag)
	    {
	        var  addUserStr=""
	        var  delUserStr=""
	        var selectLoc=$("#loc_grid").datagrid("getSelected")
	        
	        if (selectLoc)
	        {
	        	var LocID=selectLoc.DeptID
	        	var NewUserStr=""
	        	var UserRecord=$("#user_grid").datagrid("getSelections")
	        	console.log(UserRecord)
	        	if (UserRecord.length>0){
	        		for (var n=0;n<UserRecord.length;n++)
			        {
			        	if (NewUserStr=="")
			        	{
			        		NewUserStr=UserRecord[n].UserID
			        	}
			        	else
			        	{
			        		NewUserStr=NewUserStr+"^"+UserRecord[n].UserID
			        	}
			        }
	        	}
		        	
	        }
	        else
	        {
	        	return
	        }
	        if (backflag==0)	//添加权限
	        {
	        	//添加关联
		       /* var addUser=array_difference(newUser,oldUser)
		        var addUserStr=""
		        for (var m=0;m<addUser.length;m++)
		        {
		            if (addUserStr=="")
		            {
		            	addUserStr=addUser[m];	            	
		            }
		            else{
		            	addUserStr=addUserStr+"^"+addUser[m];
		            }
		            
		            
		        }*/
		         var message="保存成功！"
	            var errorMsg="保存失败！"
	            var result=tkMakeServerCall("web.CDSS.CMKB.DeptUserAuthorize","SaveDatas",LocID,NewUserStr,"");
	        }
	        else   		//收回权限
	        {
	        	//删除关联
		        /*var delUser=array_difference(oldUser,newUser)
		        var delUserStr=""
		        for (var j=0;j<delUser.length;j++)
		        {
		            if (addUserStr=="")
		            {
		            	delUserStr=delUser[j];	            	
		            }
		            else{
		            	delUserStr=delUserStr+"^"+delUser[j];
		            }

		        }  */
		        var message="权限已收回！"
	            var errorMsg="权限收回失败！"
	            var result=tkMakeServerCall("web.CDSS.CMKB.DeptUserAuthorize","SaveDatas",LocID,"",NewUserStr);
	        }
		        
	        	       
	        
	        var data = eval('('+result+')');

	        if (data.success == 'true') {
	            $.messager.popover({msg: message,type:'success',timeout: 1000});
	            
		        ClearUserList()	                                                       
	        }
	        else{
	            if (data.errorinfo) {
	                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
	            }
	            $.messager.alert('操作提示',errorMsg,"error");
	        }
	    }
	     //科室权限添加
	    $("#btnLocAble").click(function(e) {
	    	var selectLoc=$("#loc_grid").datagrid("getSelections")
	    	if (selectLoc.length>0)
	    	{
	    		var LocStr=""
	    		for (var m=0;m<selectLoc.length;m++)
	    		{
	    			if  (selectLoc[m].DeptID=="")
	    			{
	    				continue
	    			}
	    			if (LocStr=="")
	    			{
	    				LocStr=selectLoc[m].DeptID
	    			}
	    			else{
	    				LocStr=LocStr+"^"+selectLoc[m].DeptID
	    			}
	    		}
	    		if (LocStr!=""){
	    			var result=tkMakeServerCall("web.CDSS.CMKB.DeptUserAuthorize","SaveLocs",LocStr);
			        if (result == 'true') {
			        	var message="保存成功！"
			            $.messager.popover({msg: message,type:'success',timeout: 1000});
			            $("#loc_grid").datagrid("reload")
			        }
			        else{

			            $.messager.alert('操作提示',"保存失败！","error");
			        }
	    		}
	    	}
	    	else
	    	{
	    		$.messager.alert('提示','请至少选择一个科室!',"info");
	    	}
	        
	    })
	     //科室权限删除
	    $("#btnLocDisable").click(function(e) {
	        var selectLoc=$("#loc_grid").datagrid("getSelections")
	    	if (selectLoc.length>0)
	    	{
	    		var LocStr=""
	    		for (var m=0;m<selectLoc.length;m++)
	    		{
	    			if  (selectLoc[m].DeptID=="")
	    			{
	    				continue
	    			}
	    			if (LocStr=="")
	    			{
	    				LocStr=selectLoc[m].DeptID
	    			}
	    			else{
	    				LocStr=LocStr+"^"+selectLoc[m].DeptID
	    			}
	    		}
	    		if (LocStr!=""){
	    			var result=tkMakeServerCall("web.CDSS.CMKB.DeptUserAuthorize","SaveLocs",LocStr,1);
			        if (result == 'true') {
			        	var message="收回权限成功！"
			            $.messager.popover({msg: message,type:'success',timeout: 1000});
			            $("#loc_grid").datagrid("reload")
			        }
			        else{

			            $.messager.alert('操作提示',"收回权限失败！","error");
			        }
	    		}
	    	}
	    	else
	    	{
	    		$.messager.alert('提示','请至少选择一个科室!',"info");
	    	}
	    })
	    //科室查询框

	    $('#LocSearch').searchbox({
	        searcher:function(value,name){
	            SearchLocFun(value)
	        }
	    });

		$('#LocEnableSearch').combobox({ 
			data:[{
					'value':'',
					'text':'全部'
					},{
					'value':'0',
					'text':'无权限'
					},{
					'value':'1',
					'text':'有权限'
					}],
			 valueField:'value',
			 textField:'text',
			 panelHeight:'auto',
			onSelect:function(record){
				SearchLocFun()
			}
		});
		//用户查询框
	    $('#UserSearch').searchbox({
	        searcher:function(value,name){
	            SearchUserFun(value)
	        }
	    });

		$('#UserEnableSearch').combobox({ 
			data:[{
					'value':'',
					'text':'全部'
					},{
					'value':'0',
					'text':'无权限'
					},{
					'value':'1',
					'text':'有权限'
					}],
			 valueField:'value',
			 textField:'text',
			 panelHeight:'auto',
			onSelect:function(record){
				SearchUserFun()
			}
		});
		var SearchUserFun=function(){
			var deptrecord=$('#loc_grid').datagrid("getSelected")
			if (!deptrecord)
			{
				$.messager.alert('提示','请先选择一个科室!',"info");
            	return;
			}
			else{
				var deptdr=deptrecord.DeptID
				var user=$('#UserSearch').searchbox('getValue')
				var flag=$('#UserEnableSearch').combobox("getValue")
				$('#user_grid').datagrid('load', {
		            ClassName: "web.DHCBL.MKB.MKBConfig", ///调用Query时
		            QueryName: "GetUserList",
		            'q': user,
		            'deptdr':deptdr,
		            'enableflag':flag
		        })
			}
				
		}
		var SearchLocFun=function(){
			
			var locdesc=$('#LocSearch').searchbox('getValue')
			var flag=$('#LocEnableSearch').combobox("getValue")
			$('#loc_grid').datagrid('load', {
	            ClassName: "web.DHCBL.MKB.MKBConfig", ///调用Query时
	            QueryName: "GetLocList",
	            'q': locdesc,
	            'enableflag':flag
	        })							
		}
	    
	}

	$("#ConfigCode").bind("change", function() {    //为基础配置弹窗中的增改弹窗中的代码添加改变监控事件
		if($(this).val()) {
			if($HUI.combobox("#ConfigType").getValue()=="C"){
				if($(this).val()=="SDSStateDataSourse"||$(this).val()=="SDSTypeDataSourse"){
					$("#AdminConfigValue").combobox({
                        multiple:true,
                        rowStyle:'checkbox', //显示成勾选行形式
                        selectOnNavigation:false,
                        panelHeight:"auto",
                        editable:false,
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+$(this).val(),
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257 
                    });
				}
				else{
                    $("#AdminConfigValue").combobox({
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+$(this).val(),
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257 
                    });
				}
			}
		}
	});
	//代码改变时
	$("#ConfigCode").validatebox({
		onChange: function(record,r){
			if($("#ConfigType").getValue()=="C"){
				if(record=="SDSStateDataSourse"||record=="SDSTypeDataSourse"){
					$("#AdminConfigValue").combobox({
                        multiple:true,
                        rowStyle:'checkbox', //显示成勾选行形式
                        selectOnNavigation:false,
                        panelHeight:"auto",
                        editable:false,
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+record,
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257
                    });
				}
				else{
                    $("#AdminConfigValue").combobox({
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+record,
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257 
                    });
				}
			}
		}
	});
    //数据类型下拉框
    var SelectType=""
    $("#ConfigType").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'S',text:'String',"selected":true},
            {id:'N',text:'Number'},
            {id:'D',text:'Date'},
            {id:'R',text:'Radio'},
            {id:'CB',text:'CheckBox'},
            {id:'C',text:'Combox'}
        ],
        onChange: function(record,r){
			SelectType=record
			if(SelectType=='C'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='textbox hisui-combobox' data-options='' style='width:257px'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
				var TmpCode=$("#ConfigCode").val();
				//诊断来源下拉框
				if(TmpCode=="SDSStateDataSourse"||TmpCode=="SDSTypeDataSourse"){
                    $("#AdminConfigValue").combobox({
                        multiple:true,
                        rowStyle:'checkbox', //显示成勾选行形式
                        selectOnNavigation:false,
                        panelHeight:"auto",
                        editable:false,
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257 
                    });
					
				}
				else{
					$("#AdminConfigValue").combobox({
                        url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                        valueField:'id',
                        textField:'MKBSTBDesc',
                        panelWidth:257 
                    });
				}
			
			}
			if(SelectType=='S'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-validatebox' style='width:250px'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
			
			}
			if(SelectType=='N'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-numberbox' style='width:257px'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
			
			}
			if(SelectType=='D'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-datebox' style='width:257px'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
			
			}
			if(SelectType=='R'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input class='hisui-radio' id='AdminConfigValue' align='center' type='radio' value='Y' name='AdminConfigValue' style='width:15px' label='YES'><input class='hisui-radio' id='AdminConfigValue' value='N' type='radio' name='AdminConfigValue' style='width:15px' label='NO'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
			
			}
			if(SelectType=='CB'){
				if ($("#ValueRow").length>0){
					$("#ValueRow").remove();
				}
				str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' style='width:257px' type='checkbox' value='Y' class='hisui-checkbox' class='hisui-validatebox'></td></tr>";
				var targetConfig = $(str).appendTo("#form-save table");
				$.parser.parse(targetConfig);
			
			}
		}		
    });
    var DataTotal=0
	var tmpJsonData=""
	//点击修改配置按钮
    $('#btnUpdate').click(function(e){
    	var content=$('#btnUpdate').linkbutton()[0].innerText   //获取按钮名称
    	if (content=="修改配置"){
    		$('#MainShow').css('display','none');
    		$('#btnUpdate').linkbutton({text:'保存配置'});
    		btnUpdate();
    	}
    	else{           //此时为保存配置操作
    		var tmptotal=DataTotal
			var args=""
			while(tmptotal){
				var ConfigCode=tmpJsonData.rows[tmptotal-1].ConfigCode
				var ConfigType=tmpJsonData.rows[tmptotal-1].ConfigType
				if(ConfigType=='C')
				{
					var ConfigValue=$HUI.combobox("#ConfigValue"+(tmptotal-1)).getValues();
					//alert(ConfigValue+"   "+$HUI.combobox("#ConfigValue"+(tmptotal-1)).getText())
					if(ConfigValue==$HUI.combobox("#ConfigValue"+(tmptotal-1)).getText()){
						ConfigValue=comValue[tmptotal-1]
					}
				}
				if(ConfigType=='S'){
					var ConfigValue=$("#ConfigValue"+(tmptotal-1)).val();
				}
				if(ConfigType=='N'){
					var ConfigValue=$HUI.numberbox("#ConfigValue"+(tmptotal-1)).getValue();
				}
				if(ConfigType=='D'){
					var ConfigValue=$HUI.datebox("#ConfigValue"+(tmptotal-1)).getValue();
				}
				if(ConfigType=='R'){
					var ConfigValue=$("input[name='ConfigValue"+(tmptotal-1)+"']:checked").val();
				}
				if(ConfigType=='CB'){
					ConfigValue=$("input[name='ConfigValue"+(tmptotal-1)+"']:checked").val();
					if(ConfigValue!='Y')
					{
						ConfigValue='N'
					}
				}
				if(args==""){
		       		args=ConfigCode+"^"+ConfigValue+"^"+ConfigType
		       }else{
		      	 	args=args+";"+ConfigCode+"^"+ConfigValue+"^"+ConfigType
		       }
				
				tmptotal=tmptotal-1;
				
			}
			$.ajax({
				url:UPDATE_SAVE_ACTION_URL,  
				data:{
					'args':args     
				},  
				type:"POST",   
				success: function(data){
							
					var data=eval('('+data+')'); 
					if (data.success == 'true') {
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
						// $('#UpdateWin').dialog('close'); // close a dialog
					}
					else {
						var errorMsg ="更新失败！"
						if(data.errorinfo){
							errorMsg=errorMsg+'<br/>错误信息:'+data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
					}
				}
			})
			$('#MainShow').css('display','inline');
			$('#UpdateWin').css('display','none');
    		$('#btnUpdate').linkbutton({text:'修改配置'});
			var columns =[[
		        {field:'ConfigDesc',title:'配置项描述',sortable:true,width:100,styler : function(value, row, index) {
						return 'border:0;';
					},align:'right'
				},
		        {field:'ConfigValue',title:'配置项值',sortable:true,width:100,styler : function(value, row, index) {
						return 'border:0;';
					},align:'left',
					formatter: function(value,row,index){
						value=tkMakeServerCall("web.DHCBL.MKB.MKBConfig","getSingleResource",row.ConfigCode,value);
						return value
	        		}
				},
		        {field:'ID',title:'rowid',sortable:true,width:100,hidden:true}
	    	]];
		    var mygrid = $HUI.datagrid("#mygrid",{
			       	url:$URL,
			        queryParams:{
			            ClassName:"web.DHCBL.MKB.MKBConfig",          /////////***************
			            QueryName:"GetList"
			        },
			        columns: columns,  //列信息
			        singleSelect:true,
			        remoteSort:false,
			        idField:'ID',
			        showHeader:false,     
			        fixRowNumber:true,
			        fitColumns:true //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		    });
    	}
    });
    //点击基础配置按钮
    $('#btnConfig').click(function(e){
    	configPassword();
    });
    ///日期转换
    DateFormat=function(ConfigValue){
		var y = ConfigValue.substr(6,4);
		var m = ConfigValue.substr(0,2);
		var d = ConfigValue.substr(3,2);
		return y+'-'+m+'-'+d;
	}
    /* ***********************修改配置按钮功能实现******************************** */
    var comValue=new Array()
    btnUpdate=function()
	{
		//var comValue=new Array()
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBConfig",
			QueryName:"GetList"
		},function(jsonData){
			if(jsonData.total!=0){
				var i=0;
				var str=""
				tmpJsonData=jsonData
				var tmp=0
				DataTotal=jsonData.total
				while($("#trextendconfig"+tmp).length)
				{
					$("#trextendconfig"+tmp).remove();
					// console.log(tmp);
					tmp=tmp+1;
				}
				// console.log(i,jsonData.rows[i]);
				while(jsonData.rows[i])
				{
					str="<tr id='trextendconfig"+i+"'><td class='tdlabel'><font id='ConfigDesc"+i+"'>"+jsonData.rows[i].ConfigDesc+"</font></td>";
					var ConfigValue=jsonData.rows[i].ConfigValue;
				    var ConfigType=jsonData.rows[i].ConfigType;
				    switch (ConfigType) {
					    case 'S':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-validatebox' style='width:200px'";
					    break;
					    case 'N':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-numberbox' style='width:200px'";
					    break;
					    case 'D':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-datebox' style='width:200px'";
					    break;
				    	case 'R':
				    	str=str+"<td><input id='Yes"+i+"' type='radio' class='hisui-radio' value='Y' name='ConfigValue"+i+"' style='width:15px' label='YES'";
				        if(jsonData.rows[i].ConfigEdit=="N"){
							str=str+" disabled='true'><input id='No"+i+"' class='hisui-radio' value='N' type='radio' name='ConfigValue"+i+"' style='width:15px' label='NO'"
						}else{
							str=str+"><input id='No"+i+"' class='hisui-radio' value='N' type='radio' name='ConfigValue"+i+"' style='width:15px' label='NO'"
						};
				        break;
				        case 'C':
				        str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='textbox hisui-combobox' data-options='' style='width:200px'";
				        break;
				        case 'CB':
				        str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' style='width:200px' type='checkbox' value='Y' class='hisui-checkbox' class='hisui-validatebox'";
					    break;
					}
					if(jsonData.rows[i].ConfigEdit=="N"){
					    	str=str+" disabled='true'></td></tr>";
						}else{
							str=str+"></td></tr>";
					};
					var targetConfig = $(str).appendTo("#form-updatesave table");
					$.parser.parse(targetConfig);
					if(ConfigType=='C'){
						var TmpCode=jsonData.rows[i].ConfigCode
						if(TmpCode=="SDSStateDataSourse"||TmpCode=="SDSTypeDataSourse"){
							$("#ConfigValue"+i).combobox({
                                multiple:true,
                                rowStyle:'checkbox', //显示成勾选行形式
                                selectOnNavigation:false,
                                panelHeight:"auto",
                                editable:false,
                                url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                                valueField:'id',
                                textField:'MKBSTBDesc',
                                //mode:'remote',
                                panelWidth:257 
                            });
						}
						else{
                            $("#ConfigValue"+i).combobox({
                                url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                                valueField:'id',
                                textField:'MKBSTBDesc',
                                panelWidth:257 
                            });
						}
					}
				    i=i+1;
				}
				var j=0;
				while(jsonData.rows[j])
				{
					ConfigValue=jsonData.rows[j].ConfigValue;
				    ConfigType=jsonData.rows[j].ConfigType;
				    switch (ConfigType) {
					    case 'S':
					    $("#ConfigValue"+j).val(ConfigValue);
					    break;
					    case 'N':
					    $HUI.numberbox("#ConfigValue"+j).setValue(ConfigValue);
					    break;
					    case 'D':
					    {
					    	ConfigValue=DateFormat(ConfigValue)
					    	 $HUI.datebox("#ConfigValue"+j).setValue(ConfigValue);
					    }
					   
					    break;
				    	case 'R':
				    	{
							if(ConfigValue=='Y')
					    		{
					    			$HUI.radio("#Yes"+j).setValue(true);
					    		}
								else{
									$HUI.radio("#No"+j).setValue(true);
								}
						}
				        break;
				        case 'C':
				        {
				        	comValue[j]=ConfigValue
			        		$("#ConfigValue"+j).combobox('setValues',ConfigValue.split(","))
				        }
				        break;
				        case 'CB':
				        if(ConfigValue=='Y')
					    		{
					    			$("#ConfigValue"+j).checkbox('setValue',true)
					    			$("input[name='ConfigValue"+j+"'][value='Y']").attr("checked",true);
					    		}
					    break;
					}
					j=j+1;
				}
			}
		});
		$('#UpdateWin').css('display','inline')
	};
	//加载修改配置弹窗中的控件并赋值
	controlConfig=function(){
		var tmpJsonData=""
		var comValue=new Array()
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBConfig",
			QueryName:"GetList"
		},function(jsonData){
			if(jsonData.total!=0){
				var i=0;
				var str=""
				tmpJsonData=jsonData
				var tmp=jsonData.total-1
				DataTotal=jsonData.total
				while(tmp+1)
				{
					if ($("#trextendconfig"+tmp).length>0){
						$("#trextendconfig"+tmp).remove();
					}
					tmp=tmp-1;
				}
				while(jsonData.rows[i])
				{
					str="<tr id='trextendconfig"+i+"'><td class='tdlabel'><font id='ConfigDesc"+i+"'>"+jsonData.rows[i].ConfigDesc+"</font></td>";
					var ConfigValue=jsonData.rows[i].ConfigValue;
				    var ConfigType=jsonData.rows[i].ConfigType;
				    switch (ConfigType) {
					    case 'S':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-validatebox' style='width:200px'";
					    break;
					    case 'N':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-numberbox' style='width:200px'";
					    break;
					    case 'D':
					    str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='hisui-datebox' style='width:200px'";
					    break;
				    	case 'R':
				    	str=str+"<td><input id='Yes"+i+"' type='radio' class='hisui-radio' value='Y' name='ConfigValue"+i+"' style='width:15px' label='YES'";
				        if(jsonData.rows[i].ConfigEdit=="N"){
							str=str+" disabled='true'><input id='No"+i+"' class='hisui-radio' value='N' type='radio' name='ConfigValue"+i+"' style='width:15px' label='NO'"
						}else{
							str=str+"><input id='No"+i+"' class='hisui-radio' value='N' type='radio' name='ConfigValue"+i+"' style='width:15px' label='NO'"
						};
				        break;
				        case 'C':
				        str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' type='text' class='textbox hisui-combobox' data-options='' style='width:200px'";
				        break;
				        case 'CB':
				        str=str+"<td><input id='ConfigValue"+i+"' name='ConfigValue"+i+"' style='width:200px' type='checkbox' value='Y' class='hisui-checkbox' class='hisui-validatebox'";
					    break;
					}
					if(jsonData.rows[i].ConfigEdit=="N"){
					    	str=str+" disabled='true'></td></tr>";
						}else{
							str=str+"></td></tr>";
					};
					var targetConfig = $(str).appendTo("#form-updatesave table");
					$.parser.parse(targetConfig);
					if(ConfigType=='C'){
						var TmpCode=jsonData.rows[i].ConfigCode
						if(TmpCode=="SDSStateDataSourse"||TmpCode=="SDSTypeDataSourse"){
							$("#ConfigValue"+i).combobox({
                                multiple:true,
                                rowStyle:'checkbox', //显示成勾选行形式
                                selectOnNavigation:false,
                                panelHeight:"auto",
                                editable:false,
                                url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                                valueField:'id',
                                textField:'MKBSTBDesc',
                                //mode:'remote',
                                panelWidth:257 
                            });
						}
						else{
                            $("#ConfigValue"+i).combobox({
                                url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                                valueField:'id',
                                textField:'MKBSTBDesc',
                                panelWidth:257 
                            });
						}
					}
				    i=i+1;
				}
				var j=0;
				while(jsonData.rows[j])
				{
					ConfigValue=jsonData.rows[j].ConfigValue;
				    ConfigType=jsonData.rows[j].ConfigType;
				    switch (ConfigType) {
					    case 'S':
					    $("#ConfigValue"+j).val(ConfigValue);
					    break;
					    case 'N':
					    $HUI.numberbox("#ConfigValue"+j).setValue(ConfigValue);
					    break;
					    case 'D':
					    {
					    	ConfigValue=DateFormat(ConfigValue)
					    	$HUI.datebox("#ConfigValue"+j).setValue(ConfigValue);
					    }
					   
					    break;
				    	case 'R':
				    	{
							if(ConfigValue=='Y')
					    		{
					    			$HUI.radio("#Yes"+j).setValue(true);
					    		}
								else{
									$HUI.radio("#No"+j).setValue(true);
								}
						}
				        break;
				        case 'C':
				        {
				        	comValue[j]=ConfigValue
			        		$("#ConfigValue"+j).combobox('setValues',ConfigValue.split(","))
				        }
				        break;
				        case 'CB':
				        if(ConfigValue=='Y')
					    		{
					    			$("#ConfigValue"+j).checkbox('setValue',true)
					    			$("input[name='ConfigValue"+j+"'][value='Y']").attr("checked",true);
					    		}
					    break;
					}
					j=j+1;
				}
			}
		});
	}
	/* **********************************基础配置按钮的实现************************************ */
	//取消回车默认绑定事件
	$("#PasswordWin").bind("keydown",function(event){
          switch(event.keyCode){
             case 13:return false; 
             }
    });
      //密码框回车出发确定
	$("#PasswordWin").bind("keydown",function(e){
	　　// 兼容FF和IE和Opera
	　　var theEvent = e || window.event;
	　　var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
	　　 if (e.keyCode == 13) {
	　　		$("#save_btn").click();
			return false;
	　　}
	});
	//基础配置密码控制
	configPassword=function(){
		$('#PasswordWin').show();
		$('#form-password').form('clear');
		var pasWin = $HUI.dialog("#PasswordWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'基础配置密码',
			modal:true,
			buttons:[{
				text:'确定',
				id:'save_btn',
				handler:function(){
					var password=$('#ConfigPassword').val();   //获取密码框的值
					if (password=="bdp"){
						pasWin.close();
						btnConfig();
					}
					else{
						$.messager.alert('错误提示','密码输入有误，请重新输入!',"error");
					}
				}
			},{
				text:'取消',
				handler:function(){
					pasWin.close();
				}
			}]
    	});		
	};
	//基础配置弹窗
	btnConfig=function(){
		var comAdminConfigValue=""
		$('#ConfigWin').show();
    	var myWin = $HUI.dialog("#ConfigWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'基础配置',
				modal:true,
			onClose:function(){
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
			}
    	});		
	}
	//加载基础配置弹窗数据表头
	var columns =[[
        {field:'ConfigCode',title:'配置项代码',sortable:true,width:100},
        {field:'ConfigDesc',title:'配置项描述',sortable:true,width:100},
        {field:'ConfigValue',title:'配置项值',sortable:true,width:100,styler : function(value, row, index) {
			},
			formatter: function(value,row,index){
				value=tkMakeServerCall("web.DHCBL.MKB.MKBConfig","getSingleResource",row.ConfigCode,value);
				return value
    		}
		},
        {field:'ConfigType',title:'配置项类型',sortable:true,width:100},
        {field:'ConfigExplain',title:'配置项说明',sortable:true,width:100},
        {field:'ConfigActive',title:'是否激活',sortable:true,width:100,
        	formatter: function(value,row,index){
				if(value=="Y")
				{
					return "是";
				}
				else{
					return "否";
				}
        	}
    	},
        {field:'ConfigEdit',title:'是否可修改',sortable:true,width:100,
        	formatter: function(value,row,index){
				if(value=="Y")
				{
					return "是";
				}
				else{
					return "否";
				}
        	}
    	},
        {field:'ID',title:'rowid',sortable:true,width:100,hidden:true}
	]];
	//加载基础配置弹窗数据
	var mygrid = $HUI.datagrid("#grid",{
       	url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBConfigAdmin",          /////////***************
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        idField:'ID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	
	    }
   });
   
	
	var SaveDetailFunLib=function(rowid){
		var ids = [];
	    var rows = $('#detailgrid').datagrid('getSelections');

	    for(var i=0; i<rows.length; i++){
	        ids.push(rows[i].id);

	    }
	    var ids=ids.join('^')
	    console.log(ids)
	    var result = tkMakeServerCall("web.DHCBL.MKB.MKBConfig","UpdateConfigValue",rowid,ids);
		var result = eval('('+result+')');
		if (result.success == 'true') {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$('#grid').datagrid("reload")
			$('#DetailWin').dialog('close');
			$('#detailgrid').datagrid('unselectAll');
		}
		else
		{
			var errorMsg ="保存失败！"
			if (result.info) {
				errorMsg =errorMsg+ '<br/>错误信息:' + result.errorinfo
			}
			$.messager.alert('操作提示',errorMsg,"error");
		}

	}
	
	//点击添加按钮
    $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(){
    	updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	delData();
    });
     //点击搜索按钮
    $('#btnSearch').click(function(e){
		SearchFunLib();
    });
    //搜索回车事件
	$('#TextDesc,#TextCode,#TextForeignDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	});    
    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
    	var desc=$("#TextDesc").val();
    	$('#grid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBConfigAdmin",             ////////////************************
            QueryName:"GetList",
            desc:desc,
            code:code
        });
        $('#grid').datagrid('unselectAll');    	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$("#TextForeignDesc").val('');
        $('#grid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBConfigAdmin",
            QueryName:"GetList"
        });
		$('#grid').datagrid('unselectAll');
    });
    //点击添加按钮方法
    AddData=function(){
    	//alert(SelectType+"aaa")
    	if ($("#ValueRow").length>0){
				$("#ValueRow").remove();
		}
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("",1)
				}
			},{
				text:'继续新增',
				id:'save_goon',
				handler:function(){
					//goOnSaveData();
					SaveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		$HUI.checkbox("#ConfigActive").setValue(true);
		$HUI.checkbox("#ConfigEdit").setValue(true);
	}
	SaveFunLib=function(id,flagT)
	{
		var adminConfigValue=""
		var code=$.trim($("#ConfigCode").val());
		var desc=$.trim($("#ConfigDesc").val());	
		var type=$HUI.combobox("#ConfigType").getValue();
		if (code=="")
		{
			$.messager.alert('错误提示','配置项代码不能为空!',"error");
			return;
		}
		if (desc=="")
		{
			$.messager.alert('错误提示','配置项描述不能为空!',"error");
			return;
		}
		if (type=="")
		{
			$.messager.alert('错误提示','配置项类型不能为空!',"error");
			return;
		}
		if(type=='C'){
			adminConfigValue=$HUI.combobox("#AdminConfigValue").getValues();
			//alert(adminConfigValue);
			if(adminConfigValue==$HUI.combobox("#AdminConfigValue").getText()){
				adminConfigValue=comAdminConfigValue
			}
		}
		else if(type=='S'){
			adminConfigValue=$("#AdminConfigValue").val();
		}
		else if(type=='D'){
			adminConfigValue=$HUI.datebox("#AdminConfigValue").getValue();
		}
		else if(type=='N'){
			adminConfigValue=$HUI.numberbox("#AdminConfigValue").getValue();
		}
		else if(type=='R'){
			adminConfigValue=$("input[name='AdminConfigValue']:checked").val();
		}
		else if(type=='CB'){
			adminConfigValue=$("input[name='AdminConfigValue']:checked").val();
			if(adminConfigValue!='Y')
			{
				adminConfigValue='N'
			}
		}
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.ID = id;
                param.ConfigValue=adminConfigValue;
            },
				success: function (data) { 
				  	var data=eval('('+data+')'); 
				  	if (data.success == 'true') {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
				$('#grid').datagrid('reload');  // 重新载入当前页面数据 
				if(flagT==1)
				{
					$('#myWin').dialog('close'); // close a dialog
				}
				else
				{
					$('#form-save').form("clear");
					//默认选中
					$HUI.checkbox("#ConfigActive").setValue(true);
					$HUI.checkbox("#ConfigEdit").setValue(true);				
				}
			  } 
			  else { 
				var errorMsg ="更新失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
			 $.messager.alert('操作提示',errorMsg,"error");
	
				}
	
			} 
		});		
	}
	updateData=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var id=record.ID;
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBConfigAdmin",
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				if(jsonData.ConfigType=='C'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='textbox hisui-combobox' data-options='' style='width:257px'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
					//诊断来源下拉框
					var TmpCode=jsonData.ConfigCode;
				    if(TmpCode=="SDSStateDataSourse"||TmpCode=="SDSTypeDataSourse"){
						$("#AdminConfigValue").combobox({
                            multiple:true,
                            rowStyle:'checkbox', //显示成勾选行形式
                            selectOnNavigation:false,
                            panelHeight:"auto",
                            editable:false,
                            url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                            valueField:'id',
                            textField:'MKBSTBDesc',
                            panelWidth:257 
                        });
					}
					else{
                        $("#AdminConfigValue").combobox({
                            url:$URL+"?ClassName=web.DHCBL.MKB.MKBConfig&QueryName=GetDataResource&ResultSetType=array&code="+TmpCode,
                            valueField:'id',
                            textField:'MKBSTBDesc',
                            panelWidth:257 
                        });
					}
				
				}
				if(jsonData.ConfigType=='S'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-validatebox' style='width:257px'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
				
				}
				if(jsonData.ConfigType=='N'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-numberbox' style='width:257px'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
				
				}
				if(jsonData.ConfigType=='D'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' type='text' class='hisui-datebox' style='width:257px'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
				
				}
				if(jsonData.ConfigType=='R'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='Yes' class='hisui-radio' type='radio' value='Y' name='AdminConfigValue' style='width:15px' label='YES'><input id='No' value='N' class='hisui-radio' type='radio' name='AdminConfigValue' style='width:15px' label='NO'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
				
				}
				if(jsonData.ConfigType=='CB'){
					if ($("#ValueRow").length>0){
						$("#ValueRow").remove();
					}
					str="<tr id='ValueRow'><td class='tdlabel'><font>配置项值</font></td><td><input id='AdminConfigValue' name='AdminConfigValue' value='Y' style='width:257px' type='checkbox' class='hisui-checkbox' class='hisui-validatebox'></td></tr>";
					var targetConfig = $(str).appendTo("#form-save table");
					$.parser.parse(targetConfig);
				
				}
				if (jsonData.ConfigActive=="Y"){
					$HUI.checkbox("#ConfigActive").setValue(true);		
				}else{
					$HUI.checkbox("#ConfigActive").setValue(false);
				}
				if (jsonData.ConfigEdit=="Y"){
					$HUI.checkbox("#ConfigEdit").setValue(true);		
				}else{
					$HUI.checkbox("#ConfigEdit").setValue(false);
				}
				switch (jsonData.ConfigType) {
				    case 'S':
				    $("#AdminConfigValue").val(jsonData.ConfigValue);
				    break;
				    case 'N':
				    $HUI.numberbox("#AdminConfigValue").setValue(jsonData.ConfigValue);
				    break;
				    case 'D':
				    {
				    	jsonData.ConfigValue=DateFormat(jsonData.ConfigValue)
				    	$HUI.datebox("#AdminConfigValue").setValue(jsonData.ConfigValue);
				    }
				   
				    break;
			    	case 'R':
			    	{
			    		if(jsonData.ConfigValue=='Y')
			    		{
			    			$HUI.radio("#Yes").setValue(true);
			    		}
						else{
							$HUI.radio("#No").setValue(true);
						}
					}
			        break;
			        case 'C':
			        {
			        	comAdminConfigValue=jsonData.ConfigValue
		        		$("#AdminConfigValue").combobox('setValues',(jsonData.ConfigValue).split(","))
			        }
			        break;
			        case 'CB':
			        if(jsonData.ConfigValue=='Y')
			    		{
			    			$("#AdminConfigValue").checkbox('setValue',true)
			    		}
				    break;
				}
				$('#form-save').form("load",jsonData);	
			});	
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveFunLib(id,1)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
	delData=function()
	{
		var row = $("#grid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.ID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
								 $('#grid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#grid').datagrid('unselectAll');  // 清空列表选中数据 
							  } 
							  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								 $.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
}
$(init);