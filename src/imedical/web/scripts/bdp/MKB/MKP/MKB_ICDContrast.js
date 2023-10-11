﻿/*
* @Author: 基础数据平台-石萧伟
* @Date:   2019-01-01
* @Last Modified time: 2018-12-18 16:41:57
* @描述:ICD对照
*/
var init=function()
{
	//开始时将右侧面板折叠
    var SelMRCICDRowid=""; //诊断查找下拉框的诊断id
    var findCondition="";  //诊断描述
    var CacheDiagPropertyICD={}; //快速检索中属性列表获取
    var CacheDiagPropertyICDNote={}; //快速检索中属性列表备注获取
    var PreSearchText="";
    var cbg=null;//诊断combogrid
    var base=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Diagnose");
	var indexTemplate=undefined;//已选属性列表选中的模板id标识
	var SelPropertyArr=new Array();
	var SelPropertyData=""; //已选属性列表串

    var editIndex = undefined;
    var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var textForCopy = "" //复制文本用
	var defaultflag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","getYesOrNot")//获取默认版本号选项
	//设置加载第几项
	var indexArri = 0;
	changeIndex=function(index){
		setTimeout(function(){
			indexArri = index;
		},500)
	}

    /********************************************父表************************************************************************/
       var columns =[[
        {field:'ck',checkbox:true},
		{field:'Rowid',title:'rowid',sortable:true,width:100,hidden:true},
		{field:'MKBICDCode',title:'代码',sortable:true,width:150,hidden:true},
		//{field:'MKBICDTermDr',title:'国际码ID',sortable:true,width:150,hidden:true},
        {field:'MKBICDDesc',title:'ICD描述',sortable:true,width:200,
			formatter:function(value,row,index){
				if(row.MKBICDInitialICD == "Y"){
					var content = '</span><span class="besticd"><font color="#FFFFFF" style="padding:0px 2px;">优</font></span><span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				}else{
					var content = '</span><span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				}
				
				return content;		
			}
		},	
		{field:'Result',title:'结构化结果',sortable:true,width:150,
		formatter:function(value,row,index){
			//var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
			if(row.MKBICDResultRelation == "AND"){

				//var content = '<span class="andor"><font color="#FFFFFF">AND</font></span><span href="#" title="' + value + '" class="myresult">' + value + '</span>';
				var content = '<span class="andor"><font color="#FFFFFF" style="padding:0px 2px;">AND</font></span><span  id="Arr1" title="' + value + '" class="myresult">';
				var brArr =value.split('<br/>');
				for(var i = 0; i < brArr.length; i++){
					//content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/><br/>'
				    if(i==0)
                    {
                        content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br>'
                    }
                    else if(i==brArr.length-1)
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a></div>'
                    }
                    else
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/></div>'
                    }
                }; 
				content = content + '</span>'


			}else if(row.MKBICDResultRelation == "OR"){
				//var content = '<span class="andor"><font color="#FFFFFF">OR</font></span><span title="' + value + '" class="myresult">' + value + '</span>';
				var content = '<span class="andor"><font color="#FFFFFF" style="padding:0px 2px;">OR</font></span><span title="' + value + '" class="myresult">';
				var brArr =value.split('<br/>');
				for(var i = 0; i < brArr.length; i++){
					//content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/><br/>'
				    if(i==0)
                    {
                        content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br>'
                    }
                    else if(i==brArr.length-1)
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a></div>'
                    }
                    else
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/></div>'
                    }
                }; 
				content = content + '</span>'

			}else{
				//var content = '<span href="#" title="' + value + '" class="myresult">' + value + '</span>';
				var content = '<span href="#" title="' + value + '" class="myresult">';
				var brArr =value.split('<br/>');
				for(var i = 0; i < brArr.length; i++){
					//content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/><br/>'
				    if(i==0)
                    {
                        content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br>'
                    }
                    else if(i==brArr.length-1)
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a></div>'
                    }
                    else
                    {
                        content = content + '<div style="padding-top:8px"><a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/></div>'
                    }
                }; 
				content = content + '</span>'

			}
			return content;
			//return (value.replace(/\*/g,"<br/>"));
		}
	},	
		{field:'MKBICDNumber',title:'ICD编码',sortable:true,width:120,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				//return '<div style="width=100px;word-break:break-all; word-wrap:break-word;white-space:pre-wrap;">'+value+'</div>';
				return content;
			}
		},
		{field:'MKBICDExtendNumber',title:'扩展编码',sortable:true,width:80},
		{field:'MKBICDOption',title:'录入选项',sortable:true,width:150,hidden:true},
		{field:'MKBICDType',title:'类别',sortable:true,width:150,hidden:true},
		{field:'MKBICDDiaSource',title:'ICD来源标识',sortable:true,width:150,hidden:true,
			formatter:function(value,row,index){
				var str=value.replace(/&/g,"\n")
				var content = '<span href="#" title="' + str + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
        {field:'MKBICDStatus',title:'处理状态',sortable:true,width:40,
				styler:function(value,row,index){
					if(value=="Y" || value=="O"){ //已处理、已审核
						return 'background-color:#2AB66A;'; //33FF66 绿 4b991b
					}else if(value=="P"){ //预处理
						return 'background-color:#FFB746;'; //FF6600 橘 f58800
					}
                    else if(value=="R"){ //上报待处理
                        return 'background-color:#8E7F84;'; 
                    }else
                    {
                        return 'background-color:#F16E57;'; //红 ee4f38
                    }
				},				        
                formatter:function(value,row,index){
					if(value=="Y")
					{
						return '<span href="#" title="已处理"  class="mytooltip"><font color="#FFFFFF">已处理</font></span>';
					}
					else if(value=="N")
					{
						return '<span href="#" title="未处理" class="mytooltip"><font color="#FFFFFF">未处理</font></span>';
					}
					else if(value == "P")
					{
						return '<span href="#" title="预处理" class="mytooltip"><font color="#FFFFFF">预处理</font></span>';
					}
					else if(value=="G")
					{
						return '<span href="#" title="放弃" class="mytooltip"><font color="#FFFFFF">放弃</font></span>';
					}else if(value == "R"){
						return '<span href="#" title="上报待处理" class="mytooltip"><font color="#FFFFFF">上报待处理</font></span>';
					}
					else if(value == "O"){
						return '<span href="#" title="已审核" class="mytooltip"><font color="#FFFFFF">已审核</font></span>';
					}
            	}
		},
		{field:'MKBICDRemark',title:'标记',sortable:true,width:150,hidden:true,
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return "可匹配";
				}
				else if(value=="F")
				{
					return "不匹配";
				}
				else if(value == "N")
				{
					return "无匹配";
				}
				else if(value == "W")
				{
					return "待匹配";
				}
			}	
		},
        {field:'MKBICDCenterWordID',title:'参考中心词ID',sortable:true,width:100,hidden:true},
        {field:'MKBICDCenterWord',title:'参考中心词',sortable:true,width:100,
            formatter:function(value,row,index){
                //var values = value.substr(1);
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            },hidden:true
        },
        {field:'MKBICDConSegmentation',title:'分词',sortable:true,width:100,
            formatter:function(value,row,index){
                //var values = value.substr(1);
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            },hidden:true
		},  
		//{field:'MKBTDesc',title:'国际码',sortable:true,width:50,hidden:true}, 
		{field:'MKBTPDDesc',title:'中文释义',sortable:true,width:50,hidden:true},      
        {field:'MKBICDConDate',title:'操作时间',sortable:true,width:50,hidden:true},
		{field:'MKBICDConUpdateUser',title:'操作人',sortable:true,width:50,hidden:true},
		{field:'MKBICDInitialICD',title:'最优匹配',sortable:true,width:50,hidden:true},
        {field:'MKBICDResultRelation',title:'结构化结果关系',sortable:true,width:150,hidden:true}
    ]];
    var leftgrid = $HUI.datagrid("#leftgrid",{
        /*url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            MethodName:"GetNewList",
            //loc:"心内科",
			//status:"N"//默认显示未处理
			sort:0,//默认按科室总频次排序
			match:"A",
			source:defaultflag

        },*/
        columns: columns,  //列信息
		pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		
        pageSize:100,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        checkOnSelect:true,
        selectOnCheck:false,
        remoteSort:false,
        ClassTableName:'User.MKBICDContrast',
        SQLTableName:'MKB_ICDContrast',
        idField:'Rowid',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            $(this).datagrid('columnMoving');
            
            $('.myresult').tooltip({
                trackMouse:true,
                onShow:function(e){
                    $(this).tooltip('tip').css({
						//width:300 ,
						top:e.pageY+20,left:e.pageX-(250/2)
                    });
                }

			});
			firstflag = "first"//默认选中子表第一条
			$("#leftgrid").datagrid('unselectAll');
			$("#leftgrid").datagrid('uncheckAll');
		},
		onClickCell:function(index, field, value){
			//copyToCommand(value)
		},
		onDblClickCell:function(rowIndex,field,value){
			var record=$('#leftgrid').datagrid('getSelected')
			var col=$('.westgrid').children().find('tr[datagrid-row-index='+rowIndex+']');
			if(field == "MKBICDNumber" || field == "MKBICDDesc"){//ICD
				var text = (record.MKBICDNumber).slice(0,3);//只要数点前边的数字
				$('#TextInterDesc').val('');
				$('#TextInterCode').val(text);
				$('#interGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
					MethodName:"GetMyList",
					base : icdBase,
					desc : text
				});	

				//$('#ICDGrid').datagrid('unselectAll')
				var target=$(col).find('td[field=MKBICDNumber]')
				var t = $("#icdDiv")
				$("#otherDiv").hide();
				showICDDiv(target,t);	
				firstflag = "first"//默认选中子表第一条		
				//CreatPropertyDom(target,SelMRCICDRowid,SDSRowId,indexTemplate);
			}else if(field == "Result"){//跳转到二厂
                JumpToSecond()
            }
		},

        onClickRow:function(rowIndex,row)
        { 
			  //可编辑表格部分
            $('#leftgrid').datagrid('selectRow', rowIndex);
            ClickFun();

			//查询国际码
			/*var desc = (row.MKBICDNumber).slice(0,3)
			$('#TextInterCode').val(desc);
			$('#TextInterDesc').val('');
			$('#interGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
				MethodName:"GetMyList",
				base : icdBase,
				desc : desc
			});*/
            /*$('#mygrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetResultList",
                id:row.Rowid
			});*/   
			//单机才赋值url
			options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.MKBICDContrast",
				QueryName:"GetResultList",
				id:row.Rowid
			}	
			$('#mygrid').datagrid(options);	
			
            //refreshRightPanel();
			$("#mygrid").datagrid('unselectAll');
			
			loadViewTr(row);

			firstflag = "first"//默认选中子表第一条
			indexArri = 0;
            //加载右侧数据             
            setTimeout(function(){
                loadRightResult(row); 
            },200) 
        },
        onDblClickRow:function(rowIndex, field, value)
        {
            var rowData=$('#leftgrid').datagrid('getSelected');
            //DblClickFun(rowIndex,rowData,field);            
        }, 
		onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
			//右键菜单
			var $clicked=$(e.target);
			textForCopy =$clicked.text()||$clicked.val()   //普通复制功能
			
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmm = $('<div style="width:150px;"></div>').appendTo('body');
            $(
				'<div onclick="copyToCommand()" iconCls="icon-copyorder" data-options="">复制文本</div>'+
				'<div onclick="copyResultBtn()" iconCls="icon-copyorder" data-options="">复制结构化诊断</div>' +
				//'<div onclick="copyCodeBtn()" iconCls="icon-copyorder" data-options="">复制国际码</div>' +
				'<div onclick="pasteResultBtn()" iconCls="icon-paste" data-options="">粘贴</div>' +
				//'<div onclick="DeleteDiaData()" iconCls="icon-cancel" data-options="">删除</div>'+
				'<div class="menu-sep"></div>'+
				//'<div iconCls="icon-changeposition">'+
				//'<span>最优匹配</span>'+
					//'<div style="width:80px;">'+
						'<div onclick="conInitIcd(1)" iconCls="icon-ok" id="shiftup">设置最优</div>'+
						'<div onclick="conInitIcd(2)" iconCls="icon-cancel" id="shiftdown">取消最优</div>'+
					//'</div>'+
				'</div>'			
            ).appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });

			/*firstflag = "first"//默认选中子表第一条
			indexArri = 0
            //刷新表格
            $('#leftgrid').datagrid('selectRow', rowIndex);
            ClickFun();

            $('#mygrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetResultList",
                id:row.Rowid
            });           
            //refreshRightPanel();
            $("#mygrid").datagrid('unselectAll');

			loadViewTr(row);

            //加载右侧数据             
            setTimeout(function(){
                loadRightResult(row); 
            },200) */
            $('#leftgrid').datagrid('selectRow', rowIndex);
            ClickFun(); 
            //单机才赋值url
            options={};
            options.url=$URL;
            options.queryParams={
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetResultList",
                id:row.Rowid
            }   
            $('#mygrid').datagrid(options); 
            
            //refreshRightPanel();
            $("#mygrid").datagrid('unselectAll');
            
            loadViewTr(row);

            firstflag = "first"//默认选中子表第一条
            indexArri = 0;
            //加载右侧数据             
            setTimeout(function(){
                loadRightResult(row); 
            },200) 
		}   
	}); 
	//删除父表的同时删除子表
	DeleteDiaData=function(){
		var record=$('#leftgrid').datagrid('getSelected');
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}

		
		$.messager.confirm('确认','确定要删除这条数据吗?',function(r){
			if(r){
				id=record.Rowid;
				$.ajax({
					url:"./dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=DeleteDataAndChild",
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#leftgrid').datagrid('reload');
							$('#leftgrid').datagrid('unselectAll');							
						}
						else{
							var errorMsg="删除失败！";
							if(data.info){
								errorMsg=errorMsg+'</br>错误信息:'+data.info
							}
							$.messager.alert('错误提示',errorMsg,'error')
						}
					}
				});
			}
		});
	}
    //一厂跳转到二厂
    JumpToSecond = function(){
        var ICDSource = $('#TextEdition').combobox('getValue');
        var record = $('#leftgrid').datagrid('getSelected')
        var Data = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetRowData",record.Rowid)
        Data = eval('('+Data+')'); 
        var jumpidsS = Data.MKBICDConResultID
        var jumptermdrS = Data.MKBICDConTermDr
        var jumpSupplementS = Data.MKBICDConSupplement
        var jumpflagS = 1

        var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mkbicdconseconddata");
        var parentid="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
        var menuimg="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
        //判断浏览器版本
        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
        (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
        (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
        (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
        (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        //双击时跳转到对应界面
        //if(!Sys.ie){
        window.parent.closeNavTab(menuid)

        window.parent.showNavTab(menuid,"ICD对照二厂",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&jumpidsS="+jumpidsS+"&jumptermdrS="+jumptermdrS+"&jumpSupplementS="+jumpSupplementS+"&jumpflagS="+jumpflagS+"&ICDSource="+ICDSource+"&jumpflag2="+1,parentid,menuimg)

    }

	var showICDDiv=function(target,t){
        t.css({
            "left":$(window).width()*4.5/10
        })
		$('#icdDiv').show();	
		var icdDiv = $HUI.dialog("#icdDiv",{
			iconCls:'icon-updatelittle',
			resizable:true,
			title:'修改icd',
			width:$(window).width()*5/10,
			height:$(window).height()*9/10,
			modal:true
		});	
				
	}	

	//刷新左侧结构化字段
	refreshResultcolumn=function(){
		
		//setTimeout(function(){
			//前台获取第一条数据
			var record = $("#leftgrid").datagrid('getSelected')
			var resultDesc = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetSingleData",record.Rowid)
			var ANDOR = record.MKBICDResultRelation
			//自动更新ANDOR字段
			if(resultDesc.split("<br/>").length>1 && record.MKBICDResultRelation == ""){
				//如果结构化结果多余两条，并且没有维护ANDOR，则自动设置为AND
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveResultRelation",record.Rowid,"AND");
				var data=eval('('+result+')');
				if(data.success == 'true'){
					ANDOR = "AND"
				}
			}else if(resultDesc.split("<br/>").length<2 && record.MKBICDResultRelation != ""){
				//如果结构化结果少于两条，并且维护了ADNOR，则自动清空关系
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveResultRelation",record.Rowid,"");
				var data=eval('('+result+')');
				if(data.success == 'true'){
					ANDOR = ""
				}
			}
			var resultIndex = $('#leftgrid').datagrid('getRowIndex',record);
			$('#leftgrid').datagrid('getRows')[resultIndex].Result = resultDesc;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDResultRelation = ANDOR;
			$('#leftgrid').datagrid('refreshRow',resultIndex); 									
		//},500) 								
	}

	//ShowUserHabit('leftgrid');//保存用户习惯
	/*$('.westgrid .pagination').pagination({
		onRefresh:function(pageNumber, pageSize){
			alert(1)
			//$("#leftgrid").datagrid('unselectAll');
			//$("#leftgrid").datagrid('uncheckAll');
		}
	
	})*/

	//单机标记修改安妞
	$("#update_sign").popover({
		trigger:'click',
		placement:'bottom',
		//multi:true,
		title:'',
		//closeable:true,
		content:'<a id="matchY" href="javascript:void(0)" onClick="matchSign(1)">可匹配</a><br/><br/><a id="matchF" href="javascript:void(0)" onClick="matchSign(2)">不匹配</a><br/><br/><a id="matchN" href="javascript:void(0)" onClick="matchSign(3)">无匹配</a><br/><br/><a id="matchW" href="javascript:void(0)" onClick="matchSign(4)">待匹配</a>'
	});
	$("#update_sign").click(function(){
		$("#update_sign").popover('show');
	});


	matchSign = function(flagT)
	{
		if(flagT == 1){
			var flag = "Y"
		}else if(flagT == 2){
			var flag = "F"
		}else if(flagT ==3 ){
			var flag = "N"
		}else if(flagT == 4){
			var flag = "W"
		}
		var record = $('#leftgrid').datagrid('getSelected');
		if(record){
				var MKBICDRemark = flag;
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",record.Rowid,"",MKBICDRemark,"","");
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDRemark = MKBICDRemark;
				$('#leftgrid').datagrid('refreshRow',resultIndex)
				$("#update_sign").popover('hide');
				loadViewTr(record);

		}else{
			$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
			$("#update_sign").popover('hide');
            return;			
		}	
	}

/***************************************国际码开始********************************************** */
    //开始时将右侧面板折叠
    //$('#layout_resize').layout('collapse','east');	
	var interColumns=[[ 	
		{field:'MKBTRowId',title:'RowId',width:50,hidden:true}, 
		{field:'MKBTDesc',title:'国际码',width:50},
		{field:'MKBTPDDesc',title:'中文释义',width:200,
			formatter: function(value, row, index) {
			var content = '<span href="#" title="' + value + '" class="myltooltip">' + value + '</span>';
			return content;
		}},
		{field:'MKBTPDDescE',title:'英文释义',width:200,
		formatter: function(value, row, index) {
			var content = '<span href="#" title="' + value + '" class="myltooltip">' + value + '</span>';
			return content;
		}}
	]];
	$('#interGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:743,
		height:443, 
		pagination: true, 
		pageSize:PageSizeMain,
		showHeader:false,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray', 
		toolbar:'#interbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
			MethodName:"GetMyList",
			base : icdBase
		},
		singleSelect:true,
		idField:'MKBTRowId',	
		columns:interColumns,
		onDblClickRow: function (rowIndex,rowData) {
			interRest();
		},
		onLoadSuccess:function(data){
			$('.myltooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});			
		}
	});	
	//查询国际码
	$('#btninterSave').click(function(e){
		var desc = $('#TextInterCode').val();
		var descch = $('#TextInterDesc').val();
		$('#interGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
            MethodName:"GetMyList",
			base : icdBase,
			desc : desc,
			descch : descch
        });
	});
	//清屏国际码
	$('#btninterClear').click(function(e){
		$('#TextInterCode').val('');
		$('#TextInterDesc').val('');
		$('#interGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
            MethodName:"GetMyList",
			base : icdBase
        });		
	})
	//修改国际码
	/*$('#btninterReset').click(function(e){
		interRest()
	})*/
	//修改国际码
	/*interRest = function(){
		var record = $('#leftgrid').datagrid('getSelected');
		if(record){
			var interRecord = $('#interGrid').datagrid('getSelected');
			if(interRecord){
				var MKBICDTermDr = interRecord.MKBTRowId;
				var MKBTDesc = interRecord.MKBTDesc;
				var MKBTPDDesc = interRecord.MKBTPDDesc;
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",record.Rowid,"","F",MKBICDTermDr,"");
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDTermDr = MKBICDTermDr;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBTDesc = MKBTDesc;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBTPDDesc = MKBTPDDesc;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDRemark = "F";
				$('#leftgrid').datagrid('refreshRow',resultIndex)
				$("#searchForInter").popover('hide');
				loadViewTr(record);
			}else{
				$.messager.alert('错误提示','请先选择一条国际码!',"error");
				$("#searchForInter").popover('hide');
				return;	
			}

		}else{
			$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
			$("#searchForInter").popover('hide');
            return;			
		}		
	}
	//点击国际码
	interICDClick = function(obj){
		//$("#searchForInter").popover('show');
		var text = ($(obj).text()).split(".")[0];//只要数点前边的数字
		$('#TextInterDesc').val('');
		$('#TextInterCode').val(text);
		$('#interGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            MethodName:"GetMyList",
			base : icdBase,
			desc : text
        });		
	}
	//点击国际码编码	
	TPDDescClick = function(obj){
		//$("#searchForInter").popover('show');
		var text = $(obj).text();
		$('#TextInterCode').val('');
		$('#TextInterDesc').val(text);
		$('#interGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            MethodName:"GetMyList",
			base : icdBase,
			descch : text
        });			
	}*/
	/***************************************国际码结束********************************************** */
	/*******************************初始icd勾选开始******************************** */
	/*$('#Initial_ICD').checkbox({
		onCheckChange:function(e,value){
            setTimeout(function(){
					var checkFlag = $('#Initial_ICD').checkbox('getValue')
					var flagt=""
					if(checkFlag){
						flagt="Y"
					}else{
						flagt="N"
					}
					var record = $('#leftgrid').datagrid('getSelected');
					if(record){
							var MKBICDInitialICD = flagt;
							var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
							var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",record.Rowid,"","","",MKBICDInitialICD);
							$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDInitialICD = MKBICDInitialICD;
							$('#leftgrid').datagrid('refreshRow',resultIndex)
							$("#update_sign").popover('hide');
							//loadViewTr(record);
			
					}else{
						//$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
						//return;			
					}
				},50)
	
		}
	})*/
	conInitIcd = function(flag){
		if(flag == 1){
			var flagt = "Y"
		}else{
			var flagt = "N"
		}
		var record = $('#leftgrid').datagrid('getSelected');
		if(record){
				var MKBICDInitialICD = flagt;
				var icdFlag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetDescAndParid",record.Rowid);
                var icdflagdesc = icdFlag.split("*")[0] //之前最优匹配的描述
                var icdflagid = icdFlag.split("*")[1] //最优匹配在对照表中的id
                var MKBICDSource = icdFlag.split("*")[2] //数据来源
                //var MKBICDDiaSource = record.MKBICDDiaSource
                var sourceFlag=-1
                var source = $('#TextEdition').combobox('getText');
                if (icdFlag!="")
                {
                    var sourceFlag=MKBICDSource.indexOf(source)
                }
				if(flagt=="Y"&&sourceFlag!=-1){                   
                    $.messager.confirm('提示', '已有诊断短语<font color=red>'+icdflagdesc+'</font>设置为最优匹配,是否重新设置？', function(r){
                        if (r){
                            var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","InitialICDUpdate",record.Rowid,MKBICDInitialICD);
                            var result2=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","InitialICDUpdate",icdflagid,"N");
                            var data=eval('('+result+')');
                            if(data.success=='true'){
                                $.messager.popover({msg: '设置成功！',type:'success',timeout: 1000}); 
                                //searchFunLibData("");
                                var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
                                $('#leftgrid').datagrid('getRows')[resultIndex].MKBICDInitialICD = MKBICDInitialICD;
                                $('#leftgrid').datagrid('reload')
                                setTimeout(function(){
                                    $('#leftgrid').datagrid('selectRow', resultIndex); 
                                },500) 
                            }
                        }
                    })
                }else{
                    var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","InitialICDUpdate",record.Rowid,MKBICDInitialICD);
                    var data=eval('('+result+')');
                    if(data.success=='true'){       
                        var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
                        $('#leftgrid').datagrid('getRows')[resultIndex].MKBICDInitialICD = MKBICDInitialICD;
                        $('#leftgrid').datagrid('refreshRow',resultIndex)   
                        $.messager.popover({msg: '设置成功！',type:'success',timeout: 1000}); 
                    }                   
                }
		}else{
			//$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
			//return;			
		}
	}	
	/*******************************初始icd勾选结束******************************** */
	//单机参考中心词、诊断名、icd描述将内容复制到剪贴板
	copyToCommand = function(a){//a 内容标志
		//3 参考中心词  2icd描述  1 icd编码
		var record = $('#leftgrid').datagrid('getSelected')
		var text = ""
		if(a == "3"){
			text = record.MKBICDCenterWord
		}else if(a == "2"){
			text = record.MKBICDDesc
		}else if(a == "1"){
			text = record.MKBICDNumber
		}else{
			text = textForCopy
		}
		var aux = document.createElement("input");
		// 获取复制内容
		// 设置元素内容
		aux.setAttribute("value", text);
		
		// 将元素插入页面进行调用
		document.body.appendChild(aux);

		// 复制内容
		aux.select();

		// 将内容复制到剪贴板
		document.execCommand("copy");

		// 删除创建元素
		document.body.removeChild(aux);
	}	
	loadViewTr = function(row)
	{

		//初始icd
		/*$HUI.checkbox("#Initial_ICD").setValue(false)
		if(row.MKBICDInitialICD == "Y"){
			$HUI.checkbox("#Initial_ICD").setValue(true)
		}else{
			$HUI.checkbox("#Initial_ICD").setValue(false)
		}*/
		/*$('.Initial_ICD').remove();
		if(row.MKBICDInitialICD == "Y"){
			var initIcd = '<font color = green class="Initial_ICD">是</font>'
		}else{
			var initIcd = '<font color = green class="Initial_ICD">否</font>'
		}
		$('#init_icd').append(initIcd);*/
		//中文释义
		/*$('#interDescId').html("")
		if((row.MKBTPDDesc).indexOf("<br/>") >= 0){
			var MKBTPDDesc = (row.MKBTPDDesc).split("<br/>")[0].substring(0,7);
		}else{
			if((row.MKBTPDDesc).length>=10)
			{
				var MKBTPDDesc = (row.MKBTPDDesc).substring(0,7)
			}else{
				var MKBTPDDesc = row.MKBTPDDesc;
			}
			
		}*/

		/*var TPDDesc = '&nbsp&nbsp<a class="TPDDesc" href="#" onClick="TPDDescClick(this)"><font color=redgreen>'+MKBTPDDesc+'</font></a>'

		//查看所有中文释义
		$("#view_chin").popover('destroy')
		$("#view_chin").popover({
			trigger:'click',
			placement:'bottom',
			//multi:true,
			title:'',
			//closeable:true,
			content:row.MKBTPDDesc
		});
		$("#view_chin").click(function(){
			$("#view_chin").popover('show');
		});
		
		$('#interDescId').append(TPDDesc);*/

		//标记
		/*$(".sign_class").remove();
		var remark = row.MKBICDRemark
		if(row.MKBICDRemark == "Y"){
			var reDesc = "可匹配"
		}else if(row.MKBICDRemark == "N"){
			var reDesc = "无匹配"
		}else if(row.MKBICDRemark == "F"){
			var reDesc = "不匹配"
		}else if(row.MKBICDRemark == "W"){
			var reDesc = "待匹配"
		}
		var signID = '<font color=green class="sign_class">&nbsp&nbsp'+reDesc+'</font>'
		$('#signId').append(signID);

		//国际码
		//$(".interICD").remove();
		$('#interCodeId').html("")
		var interICD = '&nbsp&nbsp<a href="#" class="interICD" onClick=interICDClick(this)><font color=black>'+row.MKBTDesc+'</font></a>'
		$('#interCodeId').append(interICD);*/

        //面板标题显示
        var valbox = $HUI.panel("#myPanel",{
            iconCls:'icon-paper',
            headerCls:'panel-header-gray',
            //fit:'true',
            title:row.MKBICDDesc
            //width:800,
            //padding:5
        });
        //面板title的点击事件
        $('body').on('click','.panel-title',function () { copyToCommand(2); }); 

		//ICD编码
		$('.codeICD').remove();
		var codeP = '<a class="codeICD" href="javascript:void(0)" onClick="copyToCommand(1)"><font color=#000 >&nbsp&nbsp'+row.MKBICDNumber+'</font></a>'
		$('#codeId').append(codeP);

		//icd描述
		/*$('.view2').remove();
		//$('.trView').remove();
		if(row.MKBICDDesc != "" && (row.MKBICDDesc).length>6){
			var p2 = '<a class="view2" href="javascript:void(0)" onClick="copyToCommand(2)"><font color=#000 >&nbsp&nbsp'+(row.MKBICDDesc).substring(0,5)+'...</font></a>'
		}else{
			var p2 = '<a class="view2" href="javascript:void(0)" onClick="copyToCommand(2)"><font color=#000 >&nbsp&nbsp'+row.MKBICDDesc+'</font></a>'
		}
		$('#termViewId').append(p2);*/
		
		//参考中心词显示
		$('.view3').remove();
		if(row.MKBICDCenterWord != "" && (row.MKBICDCenterWord).length>6){
			var p3 = '<a class="view3" href="javascript:void(0)" onClick="copyToCommand(3)"><font color=#000>&nbsp&nbsp'+(row.MKBICDCenterWord).substring(0,5)+'...</font></a>'
		}else{
			var p3 = '<a class="view3" href="javascript:void(0)" onClick="copyToCommand(3)"><font color=#000>&nbsp&nbsp'+row.MKBICDCenterWord+'</font></a>'
		}
		$('#termWordId').append(p3); 
					
		//分词显示
		$('#contentId').html("")
		var indexFlag = (row.MKBICDConSegmentation).indexOf("(")
		if(indexFlag >= 0)
		{
			//中心词
			var segContent = (row.MKBICDConSegmentation).split('(')[0];
			var flagCon = segContent.indexOf("，");
			if(flagCon >= 0)
			{
				var conArr = segContent.split("，");
				for(var i = 0; i<conArr.length; i++)
				{
					if(i != (conArr.length-1))
					{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a>') //redgreen
					}
					else
					{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp(</font>') //redgreen
					}
				}
			}
			else
			{
				$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+segContent+'</font></a><font color=#017bec class="trView">&nbsp&nbsp(</font>')		//redgreen			
			}

			//属性
			var segPro = ((row.MKBICDConSegmentation).split('(')[1]).substring(0,15);
			//去掉右括号
			var segPro1= segPro
			segPro = segPro.replace(")","");
			
			var proArr = segPro.split("，")
			for(var i = 0; i<proArr.length; i++)
			{
				if(i != (proArr.length-1))
				{
					$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a>') //redgreen
				}
				else
				{
					if(segPro1.indexOf(')')>-1){
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp)</font>') //redgreen

					}else{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp...</font>') //redgreen

					}
				}
			}
		}
		else
		{
			var conArr = (row.MKBICDConSegmentation).split("，");
			for(var i = 0; i<conArr.length; i++)
			{
				$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0)" onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a>') //redgreen
			}				
		}
	}	
	//点击添加到下拉框
	putTextIntoCom = function(obj)
	{
		var thisDesc = $(obj).text()
		$('#Form_DiagPropertySearchText').searchbox('setValue',thisDesc);
		/*var ccc=$('#combogrid')
		$('#combogrid').combogrid('setValue',thisDesc)
		LoadDiagnosData(thisDesc,ccc)
		findCondition = thisDesc
		$('#combogrid').combogrid('showPanel')*/
	}
	//单击选中文本内容方法
	Myselect_txt = function(obj){
		if($(obj).focus()){

			$(obj).select();
		}
	}

	//参考中心词    //临床实用诊断
	
	$('#MKBICDConCenterWordID').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetDataForCmb1&ResultSetType=array&base=5",
		valueField:'MKBTRowId',
		textField:'MKBTDesc',
	});
	//国际码指向
	$('#MKBICDTermDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetDataForCmb1&ResultSetType=array&base=5",
		valueField:'MKBTRowId',
		textField:'MKBTDesc',
	});
	//国际码标记
	$('#MKBICDRemark').combobox({ 
		data:[{'value':'Y','text':'是'},{'value':'N','text':'否'}],
		valueField:'value',
		textField:'text'
		
	});
	//ICD来源标识
	$("#MKBICDDiaSource").combobox({
		url:$URL+"?ClassName=web.DHCBL.MKB.MKBICDContrast&QueryName=GetICDEdition&ResultSetType=array",
		valueField:'MKBTRowid',
		textField:'MKBTDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false
	});
	//处理状态
    $("#MKBICDConStatus").combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'',text:'全部'},
            {id:'Y',text:'已处理'},
			{id:'N',text:'未处理'},
			{id:'P',text:'预处理'},
			{id:'G',text:'放弃'},
			{id:'R',text:'上报待处理'}
		],
        value:''
	})

	//新增
    $('#adddia_btn').click(function(e){ //refreshRow
           AddDiaData()
    })
    AddDiaData = function() {
		$("#adddia_win").show();
		$('#adddia_form').form("clear");
        var diawin = $HUI.dialog("#adddia_win",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'save_btn',
                handler:function(){
                    SaveDiaData("");
                }
            },{
                text:'关闭',
                handler:function(){
                    diawin.close();
                }
            }]
        });
	}

    //修改
    $('#editdia_btn').click(function(e){ //refreshRow
          UpdateData()
    })

    UpdateData = function(){
		var record = $('#leftgrid').datagrid('getSelected');		
		if(record){
			if(record.MKBSDStatus=="O"){
				$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
				return;
			}
			$('#adddia_form').form("clear");
			var id=record.Rowid
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBICDContrast",
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				$('#adddia_form').form("load",jsonData);
				
				var MKBICDDiaSource=jsonData.MKBICDDiaSource
				$("#MKBICDDiaSource").combobox("setValues",MKBICDDiaSource.split(","))				
				$("#adddia_win").show(); 
				var adddia_win = $HUI.dialog("#adddia_win",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttons:[{
						text:'保存',
						id:'save_btn',
						handler:function(){
							SaveDiaData(id)
						}
					},{
						text:'关闭',
						handler:function(){
							adddia_win.close();
						}
					}]
				});		
			});
	
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}

	//诊断名保存
	SaveDiaData = function(id){
		var DIA_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBICDContrast";
		var desc=$.trim($("#MKBICDConDesc").val())
		var icdcode=$.trim($("#MKBICDConNumber").val())
		var source=$("#MKBICDDiaSource").combobox("getValues")

		if (desc=="")
		{
			$.messager.alert('错误提示','诊断描述不能为空!',"info");
			return;
		}
		if (icdcode=="")
		{
			$.messager.alert('错误提示','ICD编码不能为空!',"info");
			return;
		}
		if (source=="")
		{
			$.messager.alert('错误提示','ICD来源标识不能为空!',"info");
			return;
		}
		var val = $('#MKBICDDiaSource').combobox('getValues');  //先得到getValues值
		$('#MKBICDDiaSource').combobox('setValue',val); //再赋值给getValue

		var flag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","FormValidate",id,desc,icdcode);	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		
		
		$('#adddia_form').form('submit', { 
			url: DIA_SAVE_ACTION_URL,
			//onSubmit: function(param) {
	       //     param.MKBSDBaseDr = STBBase;
	       // }, 
			success: function (data) { 
				    var data=eval('('+data+')'); 
				    if (data.success == 'true') {
				  		$.messager.popover({msg: '提交成功!',type:'success',timeout: 1000});
						$('#MKBICDConDesc').val('');
						$("#adddia_win").dialog('close');
						searchFunLibData("");
					 } 
					else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							if((data.errorinfo).indexOf("键不唯一")){
								errorMsg =errorMsg+ '<br/>错误信息:已存在同名的数据！'
							}else{
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							
						}
						$.messager.alert('操作提示',errorMsg,"error");				
					}

			} 
		});		
	}

    //确认
    $('#result_ConfirmBtn').click(function(e){ //refreshRow
        updataStatic("Y")    
    })

	//放弃
    $('#result_GiveUpBtn').click(function(e){
        updataStatic("G")
        //$("#leftgrid").datagrid('uncheckAll');
	})
	//预处理
    $('#result_PrepareBtn').click(function(e){
        updataStatic("P")
	})
	//上报
	$('#result_reviewedbtn').click(function(e){
		updataStatic("R")
	})	
    updataStatic = function(flag){
		var records =  $('#leftgrid').datagrid('getChecked')
		//alert(JSON.stringify(records))
		if(records != ""){
			//alert(records.length)
			//var lengthR = records.length;
			for(var i = 0; i < records.length; i++){
				var record = records[i]
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				//$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDStatus = flag;
				//$('#leftgrid').datagrid('refreshRow',resultIndex)	
				if(resultIndex > -1){
					var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",record.Rowid,flag,"","","");
					var data=eval('('+result+')');
					if(data.success=='true'){   
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDStatus = flag;
						$('#leftgrid').datagrid('refreshRow',resultIndex)
					} 
				}

			}
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
	}

	//删除结果 delete_result
	$('#delete_result').click(function(e){
		var records=$("#leftgrid").datagrid("getChecked")
		if (records)
		{
			var length=records.length
			var delstr=""
			for (var m=0;m<length;m++)
			{
				if (delstr=="")
				{
					delstr=records[m].Rowid
				}
				else
				{
					delstr=delstr+","+records[m].Rowid
				}
			}
			if (delstr!="")
			{
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","DelResultOfIDStr",delstr)
				if (result=="true")
				{
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					$("#leftgrid").datagrid("reload")
				}	
				else
				{
					$.messager.alert('错误提示','删除结构化诊断错误!',"error");
				}
			}
		}
		else
		{
			$.messager.alert('错误提示','请勾选一条诊断!',"error");
			return;	
		}
	})

	/*$('#andbtn').click(function(e){
		refreshRelation("AND");
	});

	$('#orbtn').click(function(e){
		refreshRelation("OR");
	});*/
	refreshRelation = function(flagt){
		if(flagt == 1){
			var flag="AND"
		}else if(flagt == 2){
			var flag="OR"
		}
		var record =  $('#leftgrid').datagrid('getSelected');
		if(record){
			if($('#mygrid').datagrid('getData').rows.length<2){
				$.messager.alert('错误提示','仅一条结构化诊断，请查看!',"error");
				return;	
			}
			var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveResultRelation",record.Rowid,flag);
			var data=eval('('+result+')');
			if(data.success=='true'){   
				$.messager.popover({msg: '设置成功!',type:'success',timeout: 1000});
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDResultRelation = flag;
				$('#leftgrid').datagrid('refreshRow',resultIndex);	
			} 	
		}else{
			$.messager.alert('错误提示','请先在左侧列表选择一条记录!',"error");
			return;
		}
	}
    //左侧列表点击方法
    loadRightResult = function(row){
        //如果已经有诊断结果，则默认加载第一条
        //alert(row.MKBICDCenterWord)
		var ccc = $('#combogrid') 
		PreSearchText = "";//清空检索框   石萧伟20190827
        /*if($('#mygrid').datagrid('getData').total > 0){
            $('#mygrid').datagrid('selectRow',0);
            var resultSel = $('#mygrid').datagrid('getSelected')
            var termid=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetTermIdByProId",resultSel.MKBICDConTermDr); 
            var termDesc = (resultSel.MKBICDConResult).split("[")[0];
            //alert(termDesc+"*"+termid)
            CreatPropertyDom("","",termid,resultSel.Rowid,"");   
            LoadDiagnosData(termDesc,ccc);//加载诊断下拉框
            $('#combogrid').combogrid('setValue',termid);                    
            setTimeout(function(){
            //诊断列表有选中时，才允许弹出属性列表
                findCondition = "" ; 
            },50)    
            
            $("#Form_DiagDesc").val(resultSel.MKBICDConResult)

            SelMRCICDRowid = termid
        }*/ 
		//只按照匹配到的中心词展示
		//没有结构化结果时，不按照参考中心词显示
		/*if(row.MKBICDCenterWord != ""  && row.Result == ""){//&& ($('#mygrid').datagrid('getData').total == 0)){//否则按照匹配的参考中心新词来加载
            var flag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","JustTermClose",row.MKBICDCenterWordID)
			if(flag != "N"){
				var termDesc = (row.MKBICDCenterWord).split(",")[0];
				var termid = (row.MKBICDCenterWordID).split(",")[0];
				SelMRCICDRowid = termid
				CreatPropertyDom("",termid,"","");  
				LoadDiagnosData(termDesc,ccc);
				$('#combogrid').combogrid('setValue',termid); 
				SelPropertyData=""
				setTimeout(function(){
				//诊断列表有选中时，才允许弹出属性列表
					$("#Form_DiagDesc").val($('#combogrid').combogrid('getText').split('(')[0])
				},50) 
				$("#div-img").hide();
			}else{
				LoadDiagnosData("",ccc);
				$('#combogrid').combogrid('setValue',''); 
				$("#div-img").show();
			}

            //$('.view1').remove();
		}else if(row.MKBICDCenterWord == "" ){//&& ($('#mygrid').datagrid('getData').total == 0)){//都没有就不加载
			SelPropertyData=""
			LoadDiagnosData("",ccc);
			$('#combogrid').combogrid('setValue',''); 
			var newarray = new Array();
            //$('#Form_DiagPropertySearchGrid').datagrid('loadData',newarray);
			//$('#Form_DiagPropertySelectedGrid').datagrid('loadData',newarray);
            //CreatPropertyDom("","","","","");
			//$('.view1').remove();
			$("#div-img").show();
        }*/

        LoadDiagnosData("",ccc);
		$('#combogrid').combogrid('setValue',''); 
		$("#div-img").show();         
     }

	 /*****************************************************父表结束****************************************/  

    /**********************************************复制粘贴功能开始****************************************/
     //存数据的全局变量
     var dataContainer = "";
	 var copyFlag = ""
	 //复制国际码
	/* copyCodeBtn = function(){
		dataContainer = $('#leftgrid').datagrid('getSelected')
		copyFlag = 3;
	 }*/
     //父表点击复制按钮
    copyResultBtn=function(){
        dataContainer = $('#mygrid').datagrid('getData')
        copyFlag = 1;
    }
    //子表点击复制
    copyResultCBtn = function(){
		dataContainer = $('#mygrid').datagrid('getSelected')
	
        copyFlag = 2

     }


    //批量复制按钮
    $('#result_PasteAll').click(function(e){
		if(dataContainer == "")
		{
			$.messager.alert('错误提示','请先右键复制一条记录!',"error");
            return;
		}		
        var records =  $('#leftgrid').datagrid('getChecked')
        if(records != ""){
            if(copyFlag == 1){
                for(var i = 0;i < dataContainer.rows.length; i++){
                    for(var j = 0; j < records.length; j++){
                        var parId = records[j].Rowid
                        var MKBICDConResultID = dataContainer.rows[i].MKBICDConResultID
                        //alert(MKBICDConResultID)
                        var MKBICDConResult = dataContainer.rows[i].MKBICDConResult
                        var MKBICDConTermDr = dataContainer.rows[i].MKBICDConTermDr
                        var MKBICDConSupplement = dataContainer.rows[i].MKBICDConSupplement
						var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","justHasExist",parId,MKBICDConTermDr);
                        if(existStr != ""){
							//如果存在同名诊断则覆盖
							tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,existStr.split("^")[0],MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
                        }else{
                            tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);                       
						}
						var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[j])
						$('#leftgrid').datagrid('getRows')[resultIndex].Result = dataContainer.rows[0].MKBICDConResult;
						$('#leftgrid').datagrid('refreshRow',resultIndex)

                    }              
                }           
            }
            else if(copyFlag == 2){
                for(var k = 0; k < records.length; k++){
                    var parId = records[k].Rowid                
                    //var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
                    var MKBICDConResultID = dataContainer.MKBICDConResultID
                    //alert(MKBICDConResultID)
                    var MKBICDConResult = dataContainer.MKBICDConResult
                    var MKBICDConTermDr = dataContainer.MKBICDConTermDr
                    var MKBICDConSupplement = dataContainer.MKBICDConSupplement
                    var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","justHasExist",parId,MKBICDConTermDr);
                    if(existStr != ""){
                        tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,existStr.split("^")[0],MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
                    }else{                    
                        tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					}
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[k])
					$('#leftgrid').datagrid('getRows')[resultIndex].Result = dataContainer.MKBICDConResult;
					$('#leftgrid').datagrid('refreshRow',resultIndex)					

                }                  
			}
			else{
				//var record = ($('#leftgrid').datagrid('getSelected'))
				for(var i = 0;i < records.length;i++){
					var Rowid = records[i].Rowid;
					var MKBICDTermDr = dataContainer.MKBICDTermDr;
					var MKBTDesc = dataContainer.MKBTDesc;
					var MKBTPDDesc = dataContainer.MKBTPDDesc;
					tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",Rowid,"","F",MKBICDTermDr,"");
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[i])
					$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDTermDr = MKBICDTermDr;
					$('#leftgrid').datagrid('getRows')[resultIndex].MKBTDesc = MKBTDesc;
					$('#leftgrid').datagrid('getRows')[resultIndex].MKBTPDDesc = MKBTPDDesc;
					$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDRemark = "F";
					$('#leftgrid').datagrid('refreshRow',resultIndex)					
				}
				
			}
            $.messager.popover({msg: '批处理成功！',type:'success',timeout: 1000});
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
    })
    //粘贴方法
	pasteResultBtn = function(){//1是复制多条，2是复制右侧单条
		if(dataContainer == "")
		{
			$.messager.alert('错误提示','请先右键复制一条记录!',"error");
            return;
		}		
        if(copyFlag == 1){
            for(var i = 0;i < dataContainer.rows.length; i++){
                //alert(i)
                var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
                var MKBICDConResultID = dataContainer.rows[i].MKBICDConResultID
                //alert(MKBICDConResultID)
                var MKBICDConResult = dataContainer.rows[i].MKBICDConResult
                var MKBICDConTermDr = dataContainer.rows[i].MKBICDConTermDr
                var MKBICDConSupplement = dataContainer.rows[i].MKBICDConSupplement
                //判断是否存在同名（诊断模板id相同）的数据...结果传空或者是有的话传id和他的描述
                var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","justHasExist",parId,MKBICDConTermDr);
                if(existStr != ""){
					//如果存在同名诊断则覆盖
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,existStr.split("^")[0],MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}			
                    //加载右侧数据    
                    $('#mygrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBICDContrast",
                        QueryName:"GetResultList",
                        id:$('#leftgrid').datagrid('getSelected').Rowid
                    }); 
                }else{
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
                }

                
                //加载右侧数据    
                $('#mygrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.MKB.MKBICDContrast",
                    QueryName:"GetResultList",
                    id:$('#leftgrid').datagrid('getSelected').Rowid
                });                  
            }            
        }
        else if(copyFlag == 2){
                var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
                var MKBICDConResultID = dataContainer.MKBICDConResultID
                //alert(MKBICDConResultID)
                var MKBICDConResult = dataContainer.MKBICDConResult
				var MKBICDConTermDr = dataContainer.MKBICDConTermDr
                var MKBICDConSupplement = dataContainer.MKBICDConSupplement
				var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","justHasExist",parId,MKBICDConTermDr);
                if(existStr != ""){
					//tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,existStr.split("^")[0],MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
                    //加载右侧数据    
                    $('#mygrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBICDContrast",
                        QueryName:"GetResultList",
                        id:$('#leftgrid').datagrid('getSelected').Rowid
                    }); 
                }else{
					var  result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",parId,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}	
                }                    
                //加载右侧数据    
                $('#mygrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.MKB.MKBICDContrast",
                    QueryName:"GetResultList",
                    id:$('#leftgrid').datagrid('getSelected').Rowid
                });                      
		}
		else{
			var record = ($('#leftgrid').datagrid('getSelected'))
			var Rowid = record.Rowid
			var MKBICDTermDr = dataContainer.MKBICDTermDr;
			var MKBTDesc = dataContainer.MKBTDesc;
			var MKBTPDDesc = dataContainer.MKBTPDDesc;
			//alert(Rowid+"#"+MKBICDTermDr)
			var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
			var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",Rowid,"","F",MKBICDTermDr,"");
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDTermDr = MKBICDTermDr;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBTDesc = MKBTDesc;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBTPDDesc = MKBTPDDesc;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBICDRemark = "F";
			$('#leftgrid').datagrid('refreshRow',resultIndex)
			loadViewTr(record);			
		}
    }


	/**********************************************复制粘贴功能结束****************************************/
	/**********************************************子表****************************************/
	var firstflag = "first";//判断是否是默认加载第一项的标志
	var firstid = "";//保存操作项id 
    var columns =[[
        //{field:'ck',checkbox:true},
        {field:'Rowid',title:'rowid',sortable:true,width:100,hidden:true},  
        {field:'MKBICDConResultID',title:'结构化结果ID',sortable:true,width:100,hidden:true},
        {field:'MKBICDConResult',title:'结构化结果',sortable:true,width:100,
			formatter:function(value,row,index){
				if(row.MKBTActiveFlag=="N"){
					var content = '<font color=#666>诊断'+(index+1)+':</font>&nbsp&nbsp'+'<font color=red>'+value+'</font>'; //green
				}else{
					var content = '<font color=#666>诊断'+(index+1)+':</font>&nbsp&nbsp'+value; //green
				}
				return content;
			}
		},
        {field:'MKBICDConTermDr',title:'术语ID',sortable:true,width:100,hidden:true},
		{field:'MKBICDConSupplement',title:'补充诊断',sortable:true,width:100,hidden:true},
		{field:'MKBICDSequence',title:'顺序',sortable:true,width:100,
			sorter:function (a,b){  
				if(a.length > b.length) return 1;
					else if(a.length < b.length) return -1;
					else if(a > b) return 1;
					else return -1;
			},hidden:true
		},
		{field:'MKBTActiveFlag',title:'是否激活',sortable:true,width:100,hidden:true}

    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        /*url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            QueryName:"GetResultList",
            id:"-1"
        },*/
        columns: columns,  //列信息
        //pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        //pageSize:5,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
		showHeader:false,//不显示表头
		sortName : 'MKBICDSequence',
        ClassTableName:'User.MKBICDContrast',
		SQLTableName:'MKB_ICDContrast',
        idField:'Rowid',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            $(this).datagrid('columnMoving');
			//默认选中第一项
			setTimeout(function(){
				if(data.rows.length!=0 && firstflag=="first"){

						
					$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
					$('#mygrid').datagrid('selectRow',0);
					var flag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","JustTermClose",data.rows[0].MKBICDConTermDr)
					if(flag != "N"){
						SelPropertyData="";
						refreshRightPanel();
						$("#Form_DiagDesc").val(data.rows[0].MKBICDConResult)
						$("#div-img").hide();	
					}else{
						var ccc = $('#combogrid')
						LoadDiagnosData("",ccc);
						$('#combogrid').combogrid('setValue',''); 
						$("#div-img").show();
					}
		
				}else if(data.rows.length!=0 && firstflag == "up"){
					var index=$('#mygrid').datagrid('getRowIndex',firstid);  
					$('#mygrid').datagrid('selectRow',index);

				} 
			},200)          

        },
        onClickRow:function(rowIndex,row)
        {   //可编辑表格部分
            /*setTimeout(function(){
                    findCondition = selected.MKBTDesc
                },50)   */
            
			//alert(row.MKBICDConResult)
			if(row.MKBTActiveFlag=="N"){
				$.messager.alert('提示','数据已封闭!',"error");
				return;	
			}
			
			SelPropertyData="";
            refreshRightPanel();
			$("#Form_DiagDesc").val(row.MKBICDConResult)
			$("#div-img").hide();
        },
        onDblClickRow:function(rowIndex, field, value)
        {
            //var rowData=$('#mygrid').datagrid('getSelected');
            //DblClickFun(rowIndex,rowData,field);            
        }, 
		onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
			//右键菜单
			var $clicked=$(e.target);
			textForCopy =$clicked.text()||$clicked.val()   //普通复制功能
			
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmmm = $('<div style="width:160px;"></div>').appendTo('body');
            $(
				'<div onclick="refreshRelation(2)" iconCls="icon-resort" id="orbtn">OR</div>'+
				'<div onclick="refreshRelation(1)" iconCls="icon-resort" id="andbtn">AND</div>'+
				'<div onclick="copyToCommand()" iconCls="icon-copyorder" data-options="">复制文本</div>'+
                		'<div onclick="DellteStructData()" iconCls="icon-cancel" data-options="">删除</div>' +
				'<div onclick="copyResultCBtn()" iconCls="icon-copyorder" data-options="">复制结构化诊断</div>'+
				'<div onclick="OrderProperty(1)" id= "btnUp" iconCls="icon-arrow-top" data-options="">上移</div>' +
				'<div onclick="OrderProperty(2)" id = "btnDown" iconCls="icon-arrow-bottom" data-options="">下移</div>'


				/*'<div class="menu-sep"></div>'+
				'<div iconCls="icon-changeposition">'+
				'<span>诊断关系</span>'+
					'<div style="width:80px;">'+
						'<div onclick="refreshRelation(1)" iconCls="icon-resort" id="andbtn">AND</div>'+
						'<div onclick="refreshRelation(2)" iconCls="icon-resort" id="orbtn">OR</div>'+
					'</div>'+
				'</div>'*/			

            ).appendTo(mygridmmm)
            mygridmmm.menu()
            mygridmmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        }	
	});
	///结构化诊断上移下移
	OrderProperty=function (type){  
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygrid").datagrid('getRowIndex', row);	
		mysort(index, type, "mygrid")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mygrid').datagrid('getSelected');  
		var rowIndex=$('#mygrid').datagrid('getRowIndex',nowrow); 
		//遍历列表
		var order=""
		var rows = $('#mygrid').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].Rowid; //频率id
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}	
		}
		//获取级别默认值
		$.m({
			ClassName:"web.DHCBL.MKB.MKBICDContrast",
			MethodName:"SaveDragOrder",
			order:order
			},function(txtData){
		});

		refreshResultcolumn();

	} 

	//改变行号
	function mysort(index, type, gridname) {
		if (1 == type) {
			if (index != 0) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
				$('#' + gridname).datagrid('getData').rows[index] = todown;
				$('#' + gridname).datagrid('getData').rows[index - 1] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index - 1);
				$('#' + gridname).datagrid('selectRow', index - 1);
			}else{
				$.messager.popover({msg: '已经是第一个了！',type:'alert'});
			}
		} 
		else if (2 == type) {
			var rows = $('#' + gridname).datagrid('getRows').length;
			if (index != rows - 1) {
				var todown = $('#' + gridname).datagrid('getData').rows[index];
				var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
				$('#' + gridname).datagrid('getData').rows[index + 1] = todown;
				$('#' + gridname).datagrid('getData').rows[index] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index + 1);
				$('#' + gridname).datagrid('selectRow', index + 1);
			}else{
				$.messager.popover({msg: '已经是最后一个了！',type:'alert'});
			}
		}
	}
	//匹配查询框
	$("#TextMate").combobox({
		valueField:'id',
		textField:'text',
		panelWidth:150,
		data:[
			{id:'A',text:'全部'},
			{id:'D',text:'结构化诊断未匹配'},
			{id:'B',text:'结构化诊断已匹配'}
			
		],
		value:'A',
        onSelect: function(record){
            searchFunLibData("");
        }
	});
	//排序方式下拉框
    $("#TextSort").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'0',text:'ICD编码'},
			{id:'1',text:'ICD描述'},
			{id:'2',text:'RowID'},
			{id:'3',text:'结构化结果'}
        ],
        value:'2',
        onSelect: function(record){
            searchFunLibData("");
        }
	})	

    //ShowUserHabit('mygrid');//保存用户习惯
    //查询按钮
    $('#hispartsearch').click(function(e){
        searchFunLibData()
    })
    searchFunLibData = function(){
		var sort = $('#TextSort').combobox('getValue');
		var match = $('#TextMate').combobox('getValue');

        var code = $('#TextCode').val();
        var desc = $('#TextDesc').val();
        var centerword=$('#TextCenter').val(); 
		var status = $('#TextStatus').combobox('getValue');
		var source = $('#TextEdition').combobox('getValue');
        $('#leftgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            MethodName:"GetNewList",
			icd:code,
			diag:desc,
			status:status,
			source:source,
			sort:sort,
			match:match,
			centerword:centerword
        });
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            QueryName:"GetResultList",
            id:"-1"
		});
		$("#mygrid").datagrid('unselectAll');	         
        $("#leftgrid").datagrid('unselectAll');
        $("#leftgrid").datagrid('uncheckAll');
		$('#combogrid').combogrid('setValue',''); 
		$("#div-img").show();
		$('#interDescId').html("")
		$(".sign_class").remove();
		$('#interCodeId').html("")
		$('.codeICD').remove();
		//$('.Initial_ICD').remove();
		$('.view2').remove();
		$('.view3').remove();
		$('#contentId').html("")
		
		//$HUI.checkbox("#Initial_ICD").setValue(false)
	}
   /* $("#TextGen").keyup(function(){
        searchFunLibData();
    });
    $("#TextLoc").keyup(function(){
        searchFunLibData();
    });	*/
    //处理状态查询框
    $("#TextStatus").combobox({
        valueField:'id',
        textField:'text',
        data:[
			{id:'',text:'全部'},
            {id:'Y',text:'已处理'},
			{id:'N',text:'未处理'},
			{id:'P',text:'预处理'},
			{id:'G',text:'放弃'},
			{id:'R',text:'上报待处理'}
		],
		panelWidth:150,
        value:'',
        onSelect: function(record){
            searchFunLibData();
        }
	})
	
	//版本下拉框
	$("#TextEdition").combobox({
		url:$URL+"?ClassName=web.DHCBL.MKB.MKBICDContrast&QueryName=GetICDEdition&ResultSetType=array",
		valueField:'MKBTRowid',
		textField:'MKBTDesc',
		panelWidth:260,
		/*data:[
			{id:'',text:'全部'},
			{id:'A',text:'ICD-10 v6.01版'},
			//{id:'B',text:'ICD-9手术操作分类临床版'},
			//{id:'C',text:'国家版icd-9字典库2011'},
			//{id:'D',text:'手术操作分类代码国家临床版1.1'},
			{id:'B',text:'疾病分类与ICD代码(2015国家修订版)'},
			{id:'C',text:'疾病分类与代码国家临床版1.1'},
			{id:'D',text:'疾病分类与代码国家临床版2.0'}
			//{id:'H',text:'手术操作分类代码国家临床版2.0'}
		],*/
		value:defaultflag,
		onSelect: function(record){
			searchFunLibData("");
		}
	})
	
     //清屏
    $('#hispartRefresh').click(function(e){
        $('#TextCode').val('');
		$('#TextDesc').val('');
		$('#TextCenter').val('');
		//$('#TextEdition').val('');
		$('#TextStatus').combobox('setValue','');
		$('#TextEdition').combobox('setValue',defaultflag);
		$('#TextMate').combobox('setValue','A');
		var sort = $('#TextSort').combobox('getValue');

        $('#leftgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
			MethodName:"GetNewList",
			match:'A',
			source:defaultflag,
			sort:sort
            //loc:"心内科",
            //status:"N"
        });
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            QueryName:"GetResultList",
            id:"-1"
        });          
        $("#leftgrid").datagrid('unselectAll');
        $("#leftgrid").datagrid('uncheckAll');
		$('#combogrid').combogrid('setValue',''); 
		var newarray = new Array();
		var arrayRecord = $('#leftgrid').datagrid('getSelected');
		//if((arrayRecord && arrayRecord.MKBICDCenterWord == "") || ){
        	//$('#Form_DiagPropertySearchGrid').datagrid('loadData',newarray);
			//$('#Form_DiagPropertySelectedGrid').datagrid('loadData',newarray);  
		//}
		$("#div-img").show();	     
        //CreatPropertyDom("","","","","");
		$('#interDescId').html("")
		$(".sign_class").remove();
		$('#interCodeId').html("")
		$('.codeICD').remove();
		//$('.Initial_ICD').remove();
		$('.view2').remove();
		$('.view3').remove();
		$('#contentId').html("")	
		
		//$HUI.checkbox("#Initial_ICD").setValue(false)
    }) 
    //检索框单击选中输入内容
    /*$('#TextStatus').bind('click',function(){
        $('#TextStatus').select()         
    }); */    
    //数据导入按钮
    $("#btnLoad").click(function(e){
        $("#myWin").show();
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-upload',
            resizable:true,
            title:'上传',
            modal:true
        });
    })
    /*$('#delBtnForResult').click(function(e){
        DellteStructData();
    })*/

    ///删除结构化诊断
    var DELETE_Result_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=DeleteData";
    DellteStructData=function()
    {                  

        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.Rowid;
        $.messager.defaults = {ok:"确定",cancel:"取消"}//替换掉按钮文字，同时在其他地方，需要设置回来
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){
                $.ajax({
                    url:DELETE_Result_URL,  
                    data:{"id":rowid},  
                    type:"POST",   
                    //dataType:"TEXT",  
                    success: function(data){
                             //alert(data)
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') {
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                 $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
                                 $('#combogrid').combogrid('setValue','');
								 $("#div-img").show(); 
								 refreshResultcolumn();
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
/**********************************************可编辑表格开始************************************************/
    $('.datagrid-pager').find('a').each(function(){
        $(this).click(function(){
            editIndex = undefined;
            rowsvalue=undefined;
            oldrowsvalue=undefined;
            preeditIndex="";
        })
    });
    //用于单击非grid行保存可编辑行
    $(document).bind('click',function(){ 
        ClickFun();
    });
    //下拉框等组件所在显示列和隐藏列值的互换
    function UpdataRow(row,Index)
    {
        var temp;
        temp=row.MKBICDStatus;
        row.MKBICDStatus=row.MKBICDStatusF;
        row.MKBICDStatus=temp;
        $('#leftgrid').datagrid('updateRow',{
            index: Index,
            row:row
        });
    } 
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#leftgrid').datagrid('validateRow', editIndex))
        {
            $('#leftgrid').datagrid('endEdit', editIndex);
            rowsvalue=leftgrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
            return true;

        } 
        else
        {
            return false;
        }
    } 
	function ClickFun(type){   //单击执行保存可编辑行
        if (endEditing()){
            if(rowsvalue!= undefined){
                if((rowsvalue.MKBICDStatus!="")){
                    var differentflag="";
                    if(oldrowsvalue!= undefined){
                        var oldrowsvaluearr=JSON.parse(oldrowsvalue)
                        for(var params in rowsvalue){
                            if(oldrowsvaluearr[params]!=rowsvalue[params]){
                                differentflag=1
                            }
                        }
                    }
                    else{
                        differentflag=1
                    }
                    if(differentflag==1){
                        preeditIndex=editIndex
                        SaveData (rowsvalue,type);

                    }
                    else{
                        UpdataRow(rowsvalue,editIndex)
                        editIndex=undefined
                        rowsvalue=undefined
                    }
                }
                else{
                    //$.messager.alert('错误提示','标本不能为空！','error')
                    $('.messager-window').click(stopPropagation)
                    $('#leftgrid').datagrid('selectRow', editIndex)
                        .datagrid('beginEdit', editIndex);
                    //AppendDom()
                    return 0
                }
            }
        }
    } 
    function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）
        row.Rowid=row.Rowid.replace(/,/g, "")    //row中的Rowid会在数字后面自动加逗号
        if(index==editIndex){
            return
        }
        if((row!=undefined)&&(row.Rowid!=undefined)){
            UpdataRow(row,index)
        }
        preeditIndex=editIndex
        if (editIndex != index){
            if (endEditing()){
                $('#leftgrid').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $('#leftgrid').datagrid('selectRow', editIndex);
            }
        }
        oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
        //alert(oldrowsvalue)
        //AppendDom(field)
    } 
    function SaveData (record,type){
        //alert(record.MKBICDStatus)
        var result=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","EditUpdate",record.Rowid,record.MKBICDStatus,"","","");
        var data=eval('('+result+')');
        if(data.success=='true'){   
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            if(type=='AddData'){
                preeditIndex=preeditIndex+1;
            }
            record.GlPRowId=data.id
            UpdataRow(record,preeditIndex)
            if(type!='AddData'){
                editIndex=undefined
                rowsvalue=undefined
            }

        }
        else{
            var errorMsg="修改失败！";
            if(data.errorinfo){
                errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
            }
            $.messager.alert('错误提示',errorMsg,'error',function(){
                UpdataRow(record,preeditIndex)
                editIndex=undefined
                DblClickFun (preeditIndex,record);
            })
            $('.messager-window').click(stopPropagation) 
       }
    }               
/**********************************************可编辑表格结束************************************************/
    //下拉类表（诊断）
    $('#combogrid').combogrid({
        //url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTermListForDoc",
        panelWidth:500,
        panelHeight:308,
        delay: 1000,    
        mode: 'remote',  
        showHeader:false,
        fitColumns: true,   
        striped: true,   
        editable:true,   
        rownumbers:false,//序号   
        collapsible:false,//是否可折叠的   
        fit: true,//自动大小   
        pagination : true,//是否分页   
        pageSize: 8,//每页显示的记录条数，默认为10   
        pageList: [8,15,30,100,300],//可以设置每页记录条数的列表   
        method:'get', 
        idField: 'MKBTRowId',    
        textField: 'MKBTDesc',    
        columns: [[    
            {field:'MKBTDesc',title:'诊断名称',width:200,sortable:true,
                formatter:function(value,rec){ 
                    var tooltipText=value.replace(/\ +/g,"")
                    var len=value.split(findCondition).length;
                    var value1="";
                    for (var i=0;i<len;i++){
                        var otherStr=value.split(findCondition)[i];
                        if (i==0){
                            if (otherStr!=""){
                                value1=otherStr
                            }
                        }else{
                            value1=value1+"<font color='red'>"+findCondition+"</font>"+otherStr;
                        }
                    }
                    
                      //鼠标悬浮显示备注
                        var MKBTNote=rec.MKBTNote
                        MKBTNote=MKBTNote.replace(/\ /g, "")
                        MKBTNote=MKBTNote.replace(/\>/g, "大于")
                        if (MKBTNote!=""){
                            value="<span class='hisui-tooltip' title="+MKBTNote.replace(/<[^>]+>/g,"")+">"+value1+"</span>" 
                        }else{
                            value="<span class='hisui-tooltip' title="+tooltipText.replace(/<[^>]+>/g,"")+">"+value1+"</span>" 
                        }
                        return value;     
                    } 
                   
            },
            {field:'MKBTCode',title:'诊断代码',width:120,sortable:true,hidden:true},
            {field:'MKBTRowId',title:'MKBTRowId',width:120,sortable:true,hidden:true}
        ]],
        keyHandler:{
            up: function () {
                //取得选中行
                var selected = $(this).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                       $(this).combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $(this).combogrid('grid').datagrid('getRows');
                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
				}
				$("#div-img").show();
             },
             down: function () {
              //取得选中行
                var selected = $(this).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $(this).combogrid('grid').datagrid('selectRow', 0);
				}
				$("#div-img").show();
            },
            left: function () {
                return false;
            },
            right: function () {
                return false;
            },            
            enter: function () { 
                //文本框的内容为选中行的的字段内容
                var selected = $(this).combogrid('grid').datagrid('getSelected');  
                if (selected) { 
                  //DHCDocUseCount(selected.MKBTRowId, selected.MKBTDesc,"User.SDSStructDiagnos")
                  $(this).combogrid("options").value=selected.MKBTRowId;
                  SelMRCICDRowid=selected.MKBTRowId; //诊断id
                  $("#SelMKBRowId").val(SelMRCICDRowid);
                  $("#Form_DiagDesc").val(selected.MKBTDesc)
                  $("#DiagForm").empty();
                  //AddDiagnos();
				}
				$("#div-img").hide();
            },
            query:function(q){
                $(this).combogrid("setValue",q);
                var object=new Object();
                object=$(this)
                if (this.AutoSearchTimeOut) {
                    window.clearTimeout(this.AutoSearchTimeOut)
                    this.AutoSearchTimeOut=window.setTimeout(LoadDiagnosData(q,object),1000)
                }else{
                    this.AutoSearchTimeOut=window.setTimeout(LoadDiagnosData(q,object),1000)
                }
                   
                $(this).combogrid('textbox').bind('click',function(){ //2018-11-02 重新点击时 默认之前输入的值为选中状态，方便删除
                    //var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
                    //$(col).find('td[field=SDSDisplayName]').find("input").focus().select();
                    //$(this).combogrid('textbox').focus().select()
                 })
                 
                findCondition=q;
                var reg= /^[A-Za-z]+$/;
                if (reg.test(findCondition)) {
                    findCondition=findCondition.toUpperCase()
				}
				$("#div-img").show();
            }
        },
        onClickRow:function (rowIndex, rowData){
            var selected = cbg.combogrid('grid').datagrid('getSelected');             
            if (selected) {
                //石萧伟改 
                setTimeout(function(){
                    findCondition = selected.MKBTDesc
                },50)                 
                //DHCDocUseCount(selected.MKBTRowId, selected.MKBTDesc,"User.SDSStructDiagnos")
                cbg.combogrid("options").value=selected.MKBTRowId;

                SelMRCICDRowid=selected.MKBTRowId
                $("#SelMKBRowId").val(SelMRCICDRowid);
                $("#Form_DiagDesc").val(selected.MKBTDesc)
                $("#DiagForm").empty();
				//AddDiagnos();
				$("#div-img").hide();
            }
        },
        onLoadSuccess: function(){
        },
        onChange:function(newValue, oldValue){
            $("#Form_DiagDesc").val("")
            $("#DiagForm").empty();
            //RemoveSmartTip();
            if (newValue=="") {
                SelMRCICDRowid="";
            }
        },
        onShowPanel:function(){
            cbg = $(this);
            if (findCondition==""){LoadDiagnosData("",cbg)}
                //$('#Form_DiagPropertySearch').combogrid('hidePanel');//快速检索框下拉隐藏//20180905
        },
        onHidePanel:function(){
            setTimeout(function(){
				//诊断列表有选中时，才允许弹出属性列表
				var termidforjust = $('#combogrid').combogrid('getValue')
				var IdExsit=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justIdExist",termidforjust);
				
                if(SelMRCICDRowid!="" && $('#combogrid').combogrid('getText')!="" && IdExsit !=""){
					$("#div-img").hide();
                    //indexTemplate=undefined;
                    //var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
                    CreatPropertyDom("",SelMRCICDRowid,"","");
                }else{
					$("#div-img").show();
				}
            },50)
        }        
    })

    //创建可编辑属性列表控件
    function CreatPropertyDom(target,SelMRCICDRowid,Rowid,indexTemplate){
		$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
		$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
		$("#DiagForm").empty();
		//var target=$(jq1).find('td[field='+jq2+']')
		setTimeout(function(){
			//$('#Form_DiagPropertySearch').combogrid('showPanel');//快速检索框下拉弹出
			LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
		},50)
                
            /*f(target.offset().top+$("#mypropertylist").height()+30>$(window).height()){
                $("#mypropertylist").css({
                    "top": target.offset().top-$("#mypropertylist").height()-5,
                    "left": target.offset().left 
                }).show();
            }
            else{
                $("#mypropertylist").css({
                    "top": target.offset().top+30,
                    "left": target.offset().left 
                }).show();
            }*/
    }
    //加载combogrid数据
    function LoadDiagnosData(q,obj)
    {
        var desc=q;
        var opts = obj.combogrid("grid").datagrid("options");
        var queryParams = new Object(); 
        //queryParams.ClassName="web.DHCBL.MKB.MKBTermProDetail"; 
        //queryParams.QueryName="GetTermListForDoc";
        queryParams.rowid ="";
        queryParams.base =base;
        queryParams.desc =desc;
        //opts.url = $URL  
        //opts.queryParams = queryParams;
        opts.url ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTermListForDoc"
        opts.queryParams = queryParams;
        //reload 等同于'load'方法，但是它将保持在当前页。
        obj.combogrid("grid").datagrid("load");
    }
    //记录基础代码数据使用频次 User.MKBTerm
    /*function DHCDocUseCount(ValueId, ValueDesc, TableName) {
        //var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
        var FrequencyStr=TableName+"^"+ValueId+"^"+ValueDesc+"^^"
        var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPDataFrequency", "SaveData", FrequencyStr)
    }   */ 
    //分词点击方法
    /*ClickAFunLib=function(){
        $(".datagrid-cell a").unbind('dblclick').dblclick(function(e){
            //患者诊断列表，知识库端非整理标记的诊断不允许修改
            if (((flagDiagPatient=='1')&&($("#mygrid").datagrid("getSelected").SDSTag.indexOf("整理")>=0))||(flagDiagPatient=='0')){
                indexTemplate=$("#mygrid").datagrid("getSelected").SDSPropertyDR;
                setTimeout(function(){
                    var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+mygrid.getRowIndex($("#mygrid").datagrid("getSelected"))+']');
                    var record=$("#mygrid").datagrid("getSelected")
                    var Rowid=record.Rowid
                    var termid=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetTermId",record.SDSPropertyDR);
                    SelMRCICDRowid=termid;
                    $("#SelMKBRowId").val(SelMRCICDRowid);
                    $("#Form_DiagDesc").val(record.SDSDisplayName)
                    $("#Form_DiagNote").val(record.SDSDisplayName)
                    CreatPropertyDom("","",termid,Rowid,indexTemplate);
                    CacheDiagPropertyICD={};
                    CacheDiagPropertyICDNote={};
                },100)
            }
        })
        $(".datagrid-cell a").on("dblclick",function(e){
            flagNameEditor=1;
            $('#mygrid').datagrid('removeEditor','SDSDisplayName'); 
        })
    }*/    
	/******************************属性列表功能开始**************************************************************/
	//重载属性列表按钮
	$("#btnReloadPro").click(function (e) { 
		$("#DiagForm").empty();
		SelPropertyData="";
		var record=$("#mygrid").datagrid("getSelected")
		if(record){
			var Rowid=record.Rowid
		}else{
			var Rowid=""
		}
		indexTemplate=undefined;
		LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
		CacheDiagPropertyICD={};
		CacheDiagPropertyICDNote={};	
	 })
	/*****************左侧属性快速检索列表开始*******************************************/
	 var ifLoadPropertySearchGrid;
		$HUI.datagrid("#Form_DiagPropertySearchGrid",{
			columns: [[    
				{field:'text',title:'属性名称',width:200,sortable:true,
				formatter:function(value,rec){ 
				   	  //鼠标悬浮显示备注
						if (rec.note!=undefined){
							value="<span class='hisui-tooltip' title='"+(rec.note).replace(/<[^>]+>/g,"")+"'>"+value+"</span>" 
						}
						return value;
	                } 
		         },
		        {field:'note',title:'属性备注',width:200,sortable:true,hidden:true},
				{field:'id',title:'属性id',width:200,sortable:true,hidden:true}
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:100,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			onLoadSuccess:function(){
				var panel = $(this).datagrid('getPanel');   
		        var tr = panel.find('div.datagrid-body tr');   
		        tr.each(function(){   
		          	$(this).css({"height": "20px"})
		        });  
				if (ifLoadPropertySearchGrid==true){
					//setTimeout(function(){//石萧伟20190827
						DiagPropertySearch(PreSearchText,indexTemplate);
						var listArr=new Array();
						var proFrequencyStr=""
						for(i=0;i<$('#Form_DiagPropertySearchGrid').datagrid('getData').total;i++){
							var id = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].id;
							var text = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].text;
							var note = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].note;
							listArr.push({"id":id,"text":text,"note":note});
							proFrequencyStr=proFrequencyStr+"$"+id.split("#")[0]+"#"+id.split("#")[1]
						}
						proFrequencyStr=proFrequencyStr+"$"
						//属性快速检索列表数据再次取前台数组的数据
						for ( var oe in CacheDiagPropertyICD) {
							if (proFrequencyStr.indexOf("$"+oe+"$")<0){
								listArr.push({"id":oe,"text":CacheDiagPropertyICD[oe],"note":CacheDiagPropertyICDNote[oe]});
							}
						}
						ifLoadPropertySearchGrid=false
						$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
						$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');

					//},500)
				}
			},
			onClickRow:function(rowIndex,rowData){
				var selected = $('#Form_DiagPropertySearchGrid').datagrid('getSelected');  
				if (selected) { 
					var id=selected.id; 
					var trids=id.split("#")[0]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var propertyid=id.split("#")[1];
					var childId=trids.split("_")[1];
					var showType=trids.split("_")[2];
					var treeNode=trids.split("_")[4];
					var isTOrP=trids.split("_")[5];
					var tds=$("#"+trids+"").children();
					for (var j=1;j<tds.length;j++){
						//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
						var detailId=""
						var details=$("#"+trids+" td").children();
						for (var k=1;k<details.length;k++){
							if (k==1){
								detailId=details[k].id
							}
						}
						if (showType=="T"){		  
							if ((tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",childId)=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)=="其他文本描述")){
								//其他文本描述给文本框赋值
		 						var Supplement=$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
		 						if (Supplement==""){
		 							Supplement=selected.text
		 						}else{
		 							Supplement=Supplement+"，"+selected.text
		 						}
		 						$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(Supplement)
		 						$("#"+detailId+"").blur();
							}else{
								var node = $("#"+detailId+"").tree('find', propertyid);
								$("#"+detailId+"").tree("check",node.target);
						        //展示所有父节点  
						        $(node.target).show();  
						        $(".tree-title", node.target).addClass("tree-node-targeted");  
						        //展开到该节点 
						        $("#"+detailId+"").tree("expandTo",node.target);			        
						        //如果是非叶子节点，需折叠该节点的所有子节点  
						        if (!$("#"+detailId+"").tree("isLeaf",node.target)) { 
						        	$("#"+detailId+"").tree("collapse",node.target);
								} 
							}
						}
						if (showType=="C"){
							$("#"+detailId+"").combobox("select",propertyid);
						}
						if (showType=="G"){ //列表3
							var rowIndex = $("#"+childId+"_G"+isTOrP).datagrid('getRowIndex', propertyid)
							$("#"+childId+"_G"+isTOrP).datagrid("checkRow",rowIndex)
						}
						if (showType=="CB"){
							//$("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").attr("checked",true);
							$("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").click();
						}
						if (showType=="CG"){
							//$("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").attr("checked",true);
							$("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").click();
						}
					}
					CacheDiagPropertyICD={};
					CacheDiagPropertyICDNote={};
				}
			}
		})
		//左侧属性快速检索列表加载方法
		function LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc){
			//属性快速检索列表数据首先取频次表中的数据
			PreSearchText=desc.toUpperCase();
			
			setTimeout(function(){
				DiagPropertySearch(PreSearchText,indexTemplate);
				var listArr=new Array();
				//属性快速检索列表数据再次取前台数组的数据
				for ( var oe in CacheDiagPropertyICD) {

					listArr.push({"id":oe,"text":CacheDiagPropertyICD[oe],"note":CacheDiagPropertyICDNote[oe]});
					
				}
				$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
				$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');
			},700)

			ifLoadPropertySearchGrid=true;
			/*var opts = $('#Form_DiagPropertySearchGrid').datagrid("options");
			opts.url=$URL+"?ClassName=web.DHCBL.MKB.SDSDataFrequency&QueryName=GetStructProDetail&ResultSetType=array&proTemplId="+DKBBCRowId+"&indexTemplate="+indexTemplate+"&desc="+desc;
			$('#Form_DiagPropertySearchGrid').datagrid("load");	*/	
		}
		/*****************左侧属性快速检索列表结束*******************************************/
		/*****************中间已选属性列表开始*******************************************/
		$HUI.datagrid("#Form_DiagPropertySelectedGrid",{
			columns: [[    
				{field:'index',title:'index',width:30,sortable:true,hidden:true},
				{field:'titleid',title:'属性标题id',width:60,sortable:true,hidden:true},
				{field:'title',title:'属性标题',width:80,sortable:true,
					formatter:function(value,rec){ 
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+value+"</span>" 
	                } 
				},
				{field:'text',title:'已选属性',width:200,sortable:true,
					formatter:function(value,rec){ 
						var showValue=value
						if ((value!="")&&(value!=undefined)){
							if (value.length>10){
								showValue=value.substr(0,12)+"..."
							}
						}
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+showValue+"</span>" 
	                } 
		         },
				{field:'id',title:'已选属性id',width:30,sortable:true,hidden:true}
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:100,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			sortName:'index',  
    		sortOrder:'asc',
			onClickCell:function(rowIndex, field, value){
				if (field=="title"){
					$("#DiagForm").empty();
					var record=$("#mygrid").datagrid("getSelected")
					indexTemplate=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1];
					if(record && (($("#combogrid").combogrid('getValue')==record.MKBICDConTermDr))){//石萧伟
						var Rowid=record.Rowid
						setTimeout(function(){
							LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
						},100)
					}else{
						var termid = $("#combogrid").combogrid('getValue')
						setTimeout(function(){
						   LoadPropertyData(termid,"",indexTemplate);
					   },50)     						
					}	
				}else{
                    if (value=="") return;
                    var trids=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1]
                    var childId=trids.split("_")[1];
                    var showType=trids.split("_")[2];
                    var treeNode=trids.split("_")[4];
                    var isTOrP=trids.split("_")[5];
                    //var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
                    var detailId=""
                    var details=$("#"+trids+" td").children();
                    for (var k=1;k<details.length;k++){
                        if (k==1){
                            detailId=details[k].id
                        }
                    }
                    var propertyid=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].id
                    if (showType=="T"){       
                        if ((tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",childId)=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)=="其他文本描述")){
                            scrollToLocation(childId+"_T"+isTOrP+"_"+treeNode);
                        }else{
                            var node = $("#"+detailId+"").tree('find', propertyid);
                            scrollToLocation(node.target.id);
                        }
                    }
                    if (showType=="C"){
                        scrollToLocation(trids);//下拉框中的id框为隐藏控件，故根据tr行id定位
                    }
                    if (showType=="G"){ //列表
                        var rowIndex = $("#"+childId+"_G"+isTOrP).datagrid('getRowIndex', propertyid)
                        var colRow=$("#"+childId+"_G"+isTOrP).parent().children().find('tr[datagrid-row-index='+rowIndex+']')
                        scrollToLocation(colRow.attr("id"))
                    }
                    if (showType=="CB"){
                        scrollToLocation(childId+"_"+propertyid+"_CB"+isTOrP)
                    }
                    if (showType=="CG"){
                        scrollToLocation(childId+"_"+propertyid+"_CG"+isTOrP)
                    }
                }
                CacheDiagPropertyICD={};
                CacheDiagPropertyICDNote={};
			},
			/*onClickRow:function(rowIndex, rowData){
				//选中已勾选属性内容节点效果
				var trids=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var childId=trids.split("_")[1]
				var showtype=trids.split("_")[2];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				if (tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)!="其他文本描述"){
					var nodeid=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].id
					if ((nodeid!=0)&&(showtype=="T")){
						//选中已勾选属性内容节点
						var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',nodeid); 
						$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('select',node.target); 
                        //$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('checked',node.target); 
                        //node.focus();
					}
				}
                $('#Form_DiagPropertySelectedGrid').datagrid('selectRow',rowIndex)
                var scrollheight=rowIndex*100;  
                
                $(this).prev().find('div.datagrid-body').prop('scrollTop',scrollheight);
			},*/
			onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
				var $clicked=$(e.target);
				copytext =$clicked.text()||$clicked.val()   //普通复制功能
				
				e.preventDefault();  //阻止浏览器捕获右键事件
				var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
				$('#selProMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
			},
			onLoadSuccess: function(data){                      //data是默认的表格加载数据，包括rows和Total
				var mark=1;                                                 //这里涉及到简单的运算，mark是计算每次需要合并的格子数
				for (var i=1; i <data.rows.length; i++) {     //这里循环表格当前的数据
			　　　 		if(data.rows[i]['title'] == data.rows[i-1]['title']){   //后一行的值与前一行的值做比较，相同就需要合并
				　　　　	mark += 1;                                            
				　　　　　　　$(this).datagrid('mergeCells',{ 
				　　　　　　　　　　index: i+1-mark,                 //datagrid的index，表示从第几行开始合并；紫色的内容需是最精髓的，就是记住最开始需要合并的位置
				　　　　　　　　　　field: 'title',                 //合并单元格的区域，就是clomun中的filed对应的列
				　　　　　　　　　　rowspan:mark                   //纵向合并的格数，如果想要横向合并，就使用colspan：mark
				　　　　　　　}); 
			　　　　　　	}else{
			　　　　　　　		mark=1;                                         //一旦前后两行的值不一样了，那么需要合并的格子数mark就需要重新计算
			　　　　　　	}
		　　　　	}
		　}
	});
    function scrollToLocation(scrollToId) {
        var mainContainer = $('#DiagPanel');
        var scrollToContainer = $('#'+scrollToId);
        //非动画效果
        /*mainContainer.scrollTop(
            scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
        );*/
        //动画效果
        mainContainer.animate({
            scrollTop: scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
        }, 200);
    }
	/*****************中间已选属性列表结束*******************************************/
	//6个字符一换行方法
	function getNewline(val) {  
	    var str = new String(val);  
	    var bytesCount = 0;  
	    var s="";
	    for (var i = 0 ,n = str.length; i < n; i++) {  
	        var c = str.charCodeAt(i);  
	        //统计字符串的字符长度
	        if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {  
	            bytesCount += 1;  
	        } else {  
	            bytesCount += 2;  
	        }
	        //换行
	        s += str.charAt(i);
	        if((bytesCount>=6)&&(n!=3)){  
	        	s = s + '</br>';
	        	//重置
	        	bytesCount=0;
	        } 
	    }  
	    return s;  
	} 
	var ifFirstLoadPropertyData=true; //是否初次加载-是：true；否：false
	//诊断查找选择后初始化诊断属性列表页
	function LoadPropertyData(MRCICDRowid,Rowid,indexTemplate){
		//console.log(MRCICDRowid+","+Rowid+","+indexTemplate)
		var TreeCheckedIdStr="",ComboCheckedIdStr="",RadioCheckedIdStr="",CheckBoxCheckedIdStr="",GridCheckedIdStr=""//列表3
		//石萧伟
		if ((Rowid!="")){ //属性修改
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				
				var parentid=$("#leftgrid").datagrid("getSelected").Rowid;//石萧伟
				var ret=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetData",parentid,Rowid);//石萧伟
			}
		}else{
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				var ret = ""
			}
		}
		if (ret!=""){
			TreeCheckedIdStr=ret.split("^")[0];
			ComboCheckedIdStr=ret.split("^")[1];
			RadioCheckedIdStr=ret.split("^")[2];
			CheckBoxCheckedIdStr=ret.split("^")[3];
			GridCheckedIdStr = ret.split("^")[4];//列表3
		}
		SelPropertyArr=[];
		var DiagFormTool='<tr id="formTemplate" style="display:none;"><td nowrap style="white-space:nowrap;word-break:nowrap" class="td_label"><label for="email">分型1</label></td></tr>'
		$("#DiagForm").append(DiagFormTool)
		var $ff=$("#DiagForm"); //table
		var $templ=$("#formTemplate"); //tr
		var RetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDiaTemplate",MRCICDRowid) 
		if (RetStr!=""){
			var RetStrArr=RetStr.split("^");
			var DKBBCRowId=RetStrArr[0]; //属性模板Id
			var emptyInfo=RetStrArr[1];
			var modeJsonInfo=$.parseJSON(RetStrArr[2]);
			if ((indexTemplate=="")||(indexTemplate==undefined)) indexTemplate=DKBBCRowId;
			if (emptyInfo=="") {
				return ;
			}
				$(modeJsonInfo).each(function(index,item){
					var childId=modeJsonInfo[index].catRowId; 
					var childDesc=modeJsonInfo[index].catDesc; 
					var childType=modeJsonInfo[index].catType; //L列表 T树形 TX文本 S引用术语类型 C下拉框
					var showType=modeJsonInfo[index].showType;  //['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					var catFlag=modeJsonInfo[index].catFlag; //Y 表示诊断展示名
					var treeNode=modeJsonInfo[index].treeNode; //起始节点
					var choiceType=modeJsonInfo[index].choiceType; //单选多选配置：S单选;D多选
					var ifRequired=modeJsonInfo[index].ifRequired; //是否必填项:Y是；N否
					var isTOrP=modeJsonInfo[index].isTOrP; //引用属性：P，引用术语:T
					
					var trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var trName=childDesc+"_"+ifRequired;
					var proSelectFlag= true;//默认单选
					if (choiceType=="D"){
						proSelectFlag= false; //根据诊断模板获取多选
					}else{
						proSelectFlag= true;
					}
					if (childType=="L"){
						if (isTOrP=="P"){
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListDetailInfo", "", childId, "0", "1000");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTPDRowId';  
							var C_textField='comDesc'; //展示名
						}else{ //术语标识
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListTermJsonForDoc", "", childId, "", "1000", "1");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc'; //中心词
						}
					}
					if (childType=="T"){
						if (isTOrP=="P"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeDetailJson&id="+treeNode+"&property="+childId
						}else{ //术语标识
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeTermJsonForDoc&id="+treeNode+"&base="+childId
						}
					}
					if ((childType=="TX")||(childType=="TA")||(childType=="R")||(childType=="CB")||(childType=="C")){
						var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
					}
					if (childType=="S"){
						if ((showType=="C")||(showType=="CB")||(showType=="CG")||(showType=="G")) { //引用术语 展示为下拉框
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseList", childId, showType, ""); 
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc';
						}
						else if (showType=="T"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&LastLevel=&property="+childId
						}
						else{
							var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
						}
					}
					if (childType=="P"){
						var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocPropertyList",childId, ""); 
						ListRetStr=eval("("+ListRetStr+")")
						if (showType=="C") {
							var C_valueField='catRowId';  
							var C_textField='catDesc';
						}
					}
					if (childType=="SS"){
						var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSSProDetailJsonForDoc&property="+childId
					}
					var tool=$templ.clone();
					tool.removeAttr("style");
					tool.removeAttr("id");
					tool.attr("id",trId);
					tool.attr("lang",trName); //201917 title
					tool.addClass("dynamic_tr");
					tool.addClass("tr_dispaly");
					$ff.append(tool);
					//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表,隐藏其他属性列表
				 	if ((indexTemplate!=undefined)&&(indexTemplate!="")&&(indexTemplate!=DKBBCRowId)){
				 		if ((trId)!=indexTemplate){
					 		$(tool).css("display","none")
					 	}else{
					 		$(tool).css("display","")
					 	}
				 	}
				
					//属性名称列设置颜色交替变换
					if (index%2==0){
						$("td",tool).css("backgroundColor","#EEFAF4")
					}else{
						$("td",tool).css("backgroundColor","#FBF9F2")
					}
					//诊断属性悬浮显示属性名
					/*$("td",tool).tooltip({
					    position: 'right',
					    content: '<span style="color:#fff">'+childDesc+'</span>',
					    onShow: function(){
							$(this).tooltip('tip').css({
								backgroundColor: '#666',
								borderColor: '#666'
							});
					    }
					});*/
					$("label",tool).removeAttr("style");
					//['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					//必填项区分
					if (ifRequired=="Y"){
						$("label",tool).html("<font color=red>*</font>"+getNewline(childDesc));
					}else{
						$("label",tool).html(getNewline(childDesc));
					}
				
					//诊断属性单击事件gss
				     $("#"+DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP).on("click",function(event){ 
						var $dynamic_tr=$(".dynamic_tr"); 
						for (var i=0;i<($dynamic_tr.length);i++){
							var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
							if (trids!=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP)
							{
								continue;
							}
							var id=trids.split("_")[0]; //诊断模板属性id
							var showtype=trids.split("_")[2];
							var tds=$("#"+trids+"").children();
							for (var j=1;j<tds.length;j++){
								//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
								var detailId=""
								var details=$("#"+trids+" td").children();
								for (var k=1;k<details.length;k++){
									if (k==1){
										detailId=details[k].id
									}
								}
								var type=detailId.split("_")[detailId.split("_").length-2];
								if (type=="T"){
									var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
									for (var k=0;k<unCheckedNodes.length;k++){
										var nodeId=unCheckedNodes[k].id;
										var node = $("#"+detailId+"").tree('find', nodeId);
                      					$("#"+node.target.id).css("display","");
									}
										$("#"+trids).css("display","table-row");
								}
							}
						}
					}); 
					var FindSelectFlag=0;
					if (showType=="TX"){
						if (childType=="S"){
							var TXText=SRetStr.split("[A]")[2];
							var TXId=SRetStr.split("[A]")[1];
						}else{
						    var TXText=TXRetStr.split("[A]")[1];
						    var TXId=TXRetStr.split("[A]")[0];
						}
						var TX_tool="<td><label id='"+childId+"_"+TXId+"_TX"+isTOrP+"'>"+TXText+"</label></td>"  
						tool.append(TX_tool);
					}
					if (showType=="TA"){
						var TAId=""
						if (childType=="S"){
							var TAText=SRetStr.split("[A]")[2];
							TAId=SRetStr.split("[A]")[1];
						}else{
							TAId=TXRetStr.split("[A]")[0];
							var TAText=TXRetStr.split("[A]")[1];
						}
						var TA_tool="<td><textarea disabled='disabled' style='width:98%;background:transparent;border:0px;' id='"+childId+"_"+TAId+"_TA"+isTOrP+"'>"+TAText+"</textarea></td>"  
						tool.append(TA_tool);
					}
					if (showType=="CB"){
						var FindSelectCBFlag=0;
						var CBRetStr = ListRetStr;
						var TA_tool="";
						for (var k=0;k<CBRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CBId=CBRetStr.data[k].MKBTRowId;
		                        var CBDesc=CBRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CBId=CBRetStr.data[k].MKBTRowId;
		                        	var CBDesc=CBRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CBId=CBRetStr.data[k].catRowId;
		                        	var CBDesc=CBRetStr.data[k].catDesc;
								}else{
									var CBId=CBRetStr.data[k].MKBTPDRowId;
		                        	var CBDesc=CBRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+RadioCheckedIdStr+"&").indexOf("&"+CBId+"&")>=0){
		                        var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"' checked='checked'/>"+"<span>"+CBDesc+"</span>"
		                    	FindSelectFlag=1;
		                    	FindSelectCBFlag=1;
		                    	ifFirstLoadPropertyData=true;
		                    	SaveSelPropertyData(index,"selpro"+trId,childDesc,CBId,CBDesc,"add")
		                    }else{
			                    var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"'/>"+"<span>"+CBDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						if (FindSelectCBFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$('input:radio').click(function (e) { 
						   ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CB")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") //切换之前先清除
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
						   		GetSelectedPropertyStr();
						   		//InitSmartTip("","","");
						   		
						   }
						})
					}
					if (showType=="CG"){
						var FindSelectCGFlag=0;
						var CGRetStr = ListRetStr 				
						var TA_tool="";
						for (var k=0;k<CGRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CGId=CGRetStr.data[k].MKBTRowId;
		                        var CGDesc=CGRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CGId=CGRetStr.data[k].MKBTRowId;
		                        	var CGDesc=CGRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CGId=CGRetStr.data[k].catRowId;
		                        	var CGDesc=CGRetStr.data[k].catDesc;
								}else{
									var CGId=CGRetStr.data[k].MKBTPDRowId;
		                        	var CGDesc=CGRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+CheckBoxCheckedIdStr+"&").indexOf("&"+CGId+"&")>=0){
		                        var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"' checked='checked'/>"+"<span>"+CGDesc+"</span>"
		                   		FindSelectFlag=1;
		                   		FindSelectCGFlag=1;
		                        ifFirstLoadPropertyData=true;	
		                        SaveSelPropertyData(index,"selpro"+trId,childDesc,CGId,CGDesc,"add")
		                    }else{
			                    var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"'/>"+"<span>"+CGDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						if (FindSelectCGFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$('input:checkbox').click(function (e) { 
						   ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CG")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		if (e.target.checked==true){
						   			var SelPropertyType="add"
						   		}else{
						   			var SelPropertyType="remove"
						   		}
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,SelPropertyType)
						   		GetSelectedPropertyStr();
						   		//InitSmartTip("","","");
						   }
						})
					}
					if (showType=="C"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Combo_tool="<td><input class='hisui-combobox' id='"+childId+"_C"+isTOrP+"' /></td>" 
						tool.append(Combo_tool);
						$HUI.combobox("#"+childId+"_C"+isTOrP+"",{
							editable: true,
							multiple:false,
							width:'250',
							//panelHeight:'auto',
							//selectOnNavigation:true,
						  	valueField:C_valueField,   
						  	textField:C_textField,
						  	data:Data,
                			formatter:function(row){ // 鼠标悬浮显示备注
						  		if (childType=="L"){ 
						  			if (isTOrP=="P"){
										if (row.MKBTPDRemark!=""){
											return '<span class="hisui-tooltip" title="'+(row.MKBTPDRemark).replace(/<[^>]+>/g,"")+'">'+row.comDesc+'</span>';
										}else{
											return row.comDesc;
										}
						  			}else{ //术语标识
						  				return row.MKBTDesc;
						  			}
						  		}else if (childType=="S"){
						  			return row.MKBTDesc;
						  		}else if (childType=="P"){
						  			return row.catDesc;
						  		}else{
						  			return row.comDesc;
						  		}
							},
						  	onLoadSuccess:function(){
							  	if(ComboCheckedIdStr!=""){
							  		var id=""
								  	var text=""
								  	var ListData=$(this).combobox('getData');
								  	for (var m=0;m<ListData.length;m++){
								  		if (isTOrP=="T"){ //术语标识
								  			if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
											  	id=ListData[m].MKBTRowId
											  	text=ListData[m].MKBTDesc
											}
								  		}else{
										  	if (childType=="S"){
											  	if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
												  	id=ListData[m].MKBTRowId
												  	text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
												  	id=ListData[m].catRowId
												  	text=ListData[m].catDesc
												}
											}else{
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
												  	id=ListData[m].MKBTPDRowId
												  	text=ListData[m].comDesc
												}
											}
								  		}
								  		FindSelectFlag=1;
									}
									$(this).combobox('setValue', id);
								  	SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
									ifFirstLoadPropertyData=true;
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onShowPanel:function(){
								if(Data==""){
									$("#"+childId+"_C"+isTOrP+"").combobox("hidePanel");//没有下拉数据时，禁止下拉列表显示，防止点击空白的下拉列表后，属性列表隐藏，空白的下拉列表跑到页面左上角
								}else{
									if (Data.length < 7) {  
										$("#"+childId+"_C"+isTOrP+"").combobox('panel').height("auto"); //下拉数据较少时，下拉面板高度自适应
							        }else{
							        	$("#"+childId+"_C"+isTOrP+"").combobox('panel').height(200); 
							        }
								}
							},
							onSelect:function(record){
								var id=""
                				var text=""
                				if (isTOrP=="T"){
                					id=record.MKBTRowId
                					text=record.MKBTDesc;
                				}else{
                				 	if (childType=="S"){
                				 		id=record.MKBTRowId
						  				text=record.MKBTDesc;
							  		}else if (childType=="P"){
							  			id=record.catRowId
							  			text=record.catDesc;
							  		}else{
							  			id=record.MKBTPDRowId
							  			text=record.comDesc;
							  		}
                				}
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") 
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
                				GetSelectedPropertyStr();
                				//InitSmartTip("","","");
                				
							},
              				onChange:function(newValue, oldValue){
								if ((newValue=="")&&(ifFirstLoadPropertyData!=true)){
									SaveSelPropertyData(index,"selpro"+trId,childDesc,oldValue,"","remove") //清空下拉框数据时清除已选列表数据
									ifFirstLoadPropertyData=false;
									GetSelectedPropertyStr();//20180313bygss	
									//InitSmartTip("","","");
								}
							}
						});
					}
					//列表3
					if (showType=="G"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Grid_tool="<td ><table style='width:200px;max-height:200px;' id='"+childId+"_G"+isTOrP+"' border='false'></table></td>" 
						tool.append(Grid_tool);
						$HUI.datagrid("#"+childId+"_G"+isTOrP,{
							columns: [[
									{field:'ck',checkbox:true,
										styler : function(value, row, index) {
										return 'border:0;';
									}}, 
									{field:C_valueField,title:"ID",width:40,hidden:true},
									{field:C_textField,title:'描述',width:80,
										styler : function(value, row, index) {
											return 'border:0;';
										},
										formatter:function(value,row,index){ // 鼠标悬浮显示备注
											if (childType=="L"){ 
												if (isTOrP=="P"){
												  if ((row.MKBTPDRemark!="")&&(row.MKBTPDRemark!=undefined)){
													  return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark.replace(/<[^>]+>/g,"")+'">'+row.comDesc+'</span>';
												  }else{
													  return row.comDesc;
												  }
												}else{ //术语标识
													return row.MKBTDesc;
												}
											}else if (childType=="S"){
												return row.MKBTDesc;
											}else if (childType=="P"){
												return row.catDesc;
											}else{
												return row.comDesc;
											}
									    }
								}
							]],  //列信息
							showHeader:false,
							checkbox:true,
							checkOnSelect:false,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框
							selectOnCheck:false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
							pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
							singleSelect:proSelectFlag,
							idField:C_valueField, 
							rownumbers:false,    //设置为 true，则显示带有行号的列。
							fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
							remoteSort:false,  //定义是否从服务器排序数据。true
							data:Data,
							onLoadSuccess:function(data){
								if(GridCheckedIdStr!=""){
										var ListData=$(this).datagrid('getRows');
										for (var m=0;m<ListData.length;m++){
											var id=""
											var text=""
											if (isTOrP=="T"){ //术语标识
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
													id=ListData[m].MKBTRowId
													text=ListData[m].MKBTDesc
											}
											}else{
												if (childType=="S"){
													if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
														id=ListData[m].MKBTRowId
														text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
														id=ListData[m].catRowId
														text=ListData[m].catDesc
												}
											}else{
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
														id=ListData[m].MKBTPDRowId
														text=ListData[m].comDesc
												}
											}
											}
											FindSelectFlag=1;
											ifFirstLoadPropertyData=true;
											if (id!=""){
											var rowIndex=$(this).datagrid("getRowIndex",id)
											$(this).datagrid("checkRow",rowIndex)
											}
									}
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onCheck:function(rowIndex,rowData){
								var id=""
								var text=""
								if (isTOrP=="T"){
									id=rowData.MKBTRowId
									text=rowData.MKBTDesc;
								}else{
										if (childType=="S"){
											id=rowData.MKBTRowId
											text=rowData.MKBTDesc;
										}else if (childType=="P"){
											id=rowData.catRowId
											text=rowData.catDesc;
										}else{
											id=rowData.MKBTPDRowId
											text=rowData.comDesc;
										}
								}
								if (proSelectFlag==true){//单选模式
									var rows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked")
									if(rows.length>1){ 
										for (var i=0;i<rows.length;i++){
											var ids=""
											if (isTOrP=="T"){
												ids=rows[i].MKBTRowId
											}else{
													if (childType=="S"){
														ids=rows[i].MKBTRowId
													}else if (childType=="P"){
														ids=rows[i].catRowId
													}else{
														ids=rows[i].MKBTPDRowId
													}
											}
											if (ids==id) {
												continue
											}
											var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",ids)
											$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
										}
									}
								}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
								GetSelectedPropertyStr();
								//InitSmartTip("","","");
							},
							onUncheck:function(rowIndex,rowData){
								var id=""
								var text=""
								if (isTOrP=="T"){
									id=rowData.MKBTRowId
									text=rowData.MKBTDesc;
								}else{
										if (childType=="S"){
											id=rowData.MKBTRowId
											text=rowData.MKBTDesc;
										}else if (childType=="P"){
											id=rowData.catRowId
											text=rowData.catDesc;
										}else{
											id=rowData.MKBTPDRowId
											text=rowData.comDesc;
										}
								}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove") 
								ifFirstLoadPropertyData=false;
								GetSelectedPropertyStr();	
								//InitSmartTip("","","");
							}
						})
					}

					if (showType=="T"){
						if (childDesc=="文本"){
							//其他文本描述放属性列表中作为文本录入框，存到补充诊断字段
							var TA_tool="<td><textarea style='margin:2px;width:265px;height:68px' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></textarea></td>"  
							tool.append(TA_tool);
							if (Rowid!=""){
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val($("#mygrid").datagrid("getSelected").MKBICDConSupplement)
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){
									//根据SDSRowId修改补充诊断
			 						$.ajax({
										url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=UpdateSupplement",   
										data:{
											"Cid":Rowid,     ///rowid
											"Supplement":$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
										},  
										type:"POST",   
										success: function(data){
												  var data=eval('('+data+')'); 
												  if (data.success == 'true') {
												  	  //UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
												  	  if ($("#mygrid").datagrid("getSelected").MKBICDConSupplement!=""){
												  	  		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove")
												  	  }
												  	  ifFirstLoadPropertyData=false;
												  	  if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
												  	 		SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
												  	  }
												  } 
												  else { 
														var errorMsg ="补充诊断保存失败！"
														if (data.info) {
															errorMsg =errorMsg+ '<br/>错误信息:' + data.info
														}
														$.messager.alert('操作提示',errorMsg,"error");
												}			
										}  
									})
									
								})
							}else{//石萧伟加当rowid为空时
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){
									ifFirstLoadPropertyData=false;
									if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
										   SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
									}
								})							
							}
							
							if ($("#mygrid").datagrid("getSelected")&&($("#mygrid").datagrid("getSelected").MKBICDConSupplement!="")&&(($("#mygrid").datagrid("getSelected").MKBICDConSupplement!=undefined))){
								SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#mygrid").datagrid("getSelected").MKBICDConSupplement,$("#mygrid").datagrid("getSelected").MKBICDConSupplement,"add")
							}else{
								SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add") //初始化已选属性文本标题
							}
						}else{
								var tmpTreeCheckedIdStr=TreeCheckedIdStr;
								var FindSelectFlag=0;
								var Tree_tool="<td width=400><ul class='hisui-tree' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></ul></td>"
								tool.append(Tree_tool);
								var tree=$HUI.tree("#"+childId+"_T"+isTOrP+"_"+treeNode+"",{
									checkbox:true,
									//onlyLeafCheck:true,
									lines:true,
									multiple:proSelectFlag,
									cascadeCheck:false,
									//data:TreeRetStr,
									url:TreeRetUrl, 
									formatter:function(node){
										if (childType=="T"){
			              					//鼠标悬浮显示备注
			                  				var remark=node.text.split("^")[3].split("</span>")[0];
											if (remark!=""){
												return '<span class="hisui-tooltip" title="'+remark.replace(/<[^>]+>/g,"")+'">'+node.text+'</span>';
											}else{
												return node.text;
											}
										}else{
											return node.text;
										}
									},
									onContextMenu: function(e, node){ //诊断属性右键菜单gss   
														e.preventDefault();  //阻止右键默认事件 
													    $("#NodeMenu").empty(); //	清空已有的菜单
														$(this).tree('select',node.target);
	 
														$('#NodeMenu').menu('appendItem', {
															text:"知识点",
															iconCls:'icon-productimage',
															onclick:function(){
																var height=parseInt(window.screen.height)-120;
																var width=parseInt(window.screen.width)-50;
																if (isTOrP=="P"){
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+MRCICDRowid+"&ProId="+childId+"&detailId="+node.id; 
																}else{
																	var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+termmenuid+"&TermID="+node.id+"&ProId="; 
																}
																var listtermWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ listtermWin.document.title = '知识点'; }, 150)
															}
														})
														$('#NodeMenu').menu('appendItem', {
															text:"关联ICD",
															iconCls:'icon-paper-link',
															onclick:function(){
																var wordVersion=tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","SDSDataSource");
																var height=parseInt(window.screen.height)-150;
																var width=parseInt(window.screen.width)-80;
																var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id+"&version="+wordVersion+"&dblflag=N&DiagnosValue="; 
																var relatedicdWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ relatedicdWin.document.title = '关联ICD'; }, 100)
															}
														})
														$('#NodeMenu').menu('appendItem', {
															text:"相关文献",
															iconCls:'icon-paper',
															onclick:function(){
								                            	var repUrl="dhc.bdp.mkb.mkbrelateddocuments.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id; 
																var documentsWin=window.open(repUrl,"_blank","height=600,width=1000,left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ documentsWin.document.title = '相关文献'; }, 100)
															}
														})
														$('#NodeMenu').menu('show', {    
															left: e.pageX+10,    
															top: e.pageY+5   
														}); 
											}, 
									onClick:function(node){
										if (node.checked){
											$(this).tree('uncheck',node.target)  
										}else{
											$(this).tree('check',node.target)  
										}
									},
									onCheck:function(node, checked){
										var SelPropertyType=""
										if (checked==true){
											if (node.checked==false){
												SelPropertyType="add"
											}
										}else{
											SelPropertyType="remove"
										}
										ifFirstLoadPropertyData=false;
										if (proSelectFlag==false){//多选模式
											if (checked){
											   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
											}
										}else{
											var nodes =$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getChecked');
											if(nodes.length>1){ 
												for (var i=0;i<nodes.length;i++){
													var ids=nodes[i].id;
													if (ids==node.id) {
													
														continue
													}
													var node1 = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',ids); 
													$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node1.target);
												}
										    }
											   
										}
										//获取当前选中节点的所有父节点 concat
										 var parentAll = "";
										 parentAll = node.text.split("<span class='hidecls'>")[0];
										 var flag = "，";
										 var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',node.id).target); //获取选中节点的父节点
										 for (n = 0; n < 6; n++) { //可以视树的层级合理设置k
										     if (parent != null) {
										         parentAll = flag.concat(parentAll);
										         parentAll = (parent.text.split("<span class='hidecls'>")[0]).concat(parentAll);
										         var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', parent.target);
										     }
										 }
										 parentAll=parentAll.split("，").reverse().join("，"); //父子级倒序显示
										 if (SelPropertyType=="add"){
											SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										 else if(SelPropertyType=="remove"){
										 	SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										GetSelectedPropertyStr();//gssby20180302
										//InitSmartTip("","","");
									},	
									onLoadSuccess:function(node, data){
										//$('.mytooltip').tooltip();
										var Roots=$(this).tree('getRoots');
										for (var j=0;j<Roots.length;j++){
											if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
										}
										
										if (TreeCheckedIdStr!=""){
											for (var m=0;m<TreeCheckedIdStr.split("&").length;m++){
												var tmpnode = $(this).tree('find', TreeCheckedIdStr.split("&")[m]);
												if (tmpnode){
													$(this).tree('check', tmpnode.target);
													$(this).tree("expandTo",tmpnode.target);
													FindSelectFlag=1;
													ifFirstLoadPropertyData=true;
												}
											}
										}
										
										for (var j=0;j<Roots.length;j++){
												if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
										}
										
										tmpTreeCheckedIdStr="";
										SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
										//去掉treegrid结点前面的文件及文件夹小图标
										//$("#"+childId+"_T_"+treeNode+".tree-icon,#"+childId+"_T_"+treeNode+" .tree-file").removeClass("tree-icon tree-file");
										//$("#"+childId+"_T_"+treeNode+" .tree-icon,#"+childId+"_T_"+treeNode+" .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
									}
								})
						}
					}
					if (FindSelectFlag==1){
						ifFirstLoadPropertyData=true;
						$("#"+DKBBCRowId+"_"+childId+"_"+showType+isTOrP+"").removeClass("tr_dispaly");
						$("#"+childId+"_Empty_CG").attr('checked',true);
					}
				})
            //石萧伟
            if (findCondition==""){
                findCondition=$('.combogrid-f').combo("getText");
            }else{
                setTimeout(function(){
                    findCondition=$('.combogrid-f').combo("getText");
                    //alert(findCondition)
                },50)
            }				
			/*****************左侧属性快速检索列表开始*******************************************/
			LoadFormPropertySearchData(DKBBCRowId,indexTemplate,"")
			//属性列表检索框定义
			 $('#Form_DiagPropertySearchText').searchbox({
			   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
					if (emptyInfo!=""){
						PreSearchText=value.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,value)
					}else{
						$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
					}
			   }
			})
			$('#Form_DiagPropertySearchText').searchbox('setValue','')
			$('#Form_DiagPropertySearchText').searchbox('textbox').focus();
			//属性列表检索框实时检索
			var flagPropertyTime=""
			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keyup').keyup(function(e){  
				if (emptyInfo!=""){
					clearTimeout(flagPropertyTime);
					flagPropertyTime=setTimeout(function(){
						var desc=$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
						PreSearchText=desc.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc)
					},800)
				}else{
					$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
				}
   			}); 	
 			$('#Form_DiagPropertySearchText').searchbox('textbox').bind('click',function(){ 
 				$('#Form_DiagPropertySearchText').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
 			});
 			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keydown').keydown(function(e){
 				//单击其他描述获取到的属性检索列表，输入检索条件enter保存到知识库其他描述-其他文本描述节点下，同时修改到补充诊断字段
 				if ((e.keyCode == 13)&&(indexTemplate.indexOf("_")>-1)&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",indexTemplate.split("_")[1])=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",indexTemplate.split("_")[4])=="其他文本描述")){
 						//保存到知识库其他文本描述节点下
 						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=AddDataToOtherTextPro",   
							data:{
								"proId":indexTemplate.split("_")[1],     ///rowid
								"text":$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
							},  
							type:"POST",   
							success: function(data){
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  } 
									  else { 
											var errorMsg ="同步知识库文本失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											$.messager.alert('操作提示',errorMsg,"error");
									}			
							}  
						})
 						
 						//其他文本描述赋值
 						var Supplement=$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val()
 						if (Supplement==""){
 							Supplement=$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}else{
 							Supplement=Supplement+"，"+$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}
 						$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val(Supplement)
 						//根据SDSRowId修改补充诊断
 						var index=""
 						var trId=""
 						$(modeJsonInfo).each(function(i,item){
 							var childId=modeJsonInfo[i].catRowId; 
							var childDesc=modeJsonInfo[i].catDesc; 
							var childType=modeJsonInfo[i].catType; 
							var showType=modeJsonInfo[i].showType;  
							var treeNode=modeJsonInfo[i].treeNode; 
							var isTOrP=modeJsonInfo[i].isTOrP; 
							if (childDesc=="文本"){
								index=i
								trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
								return;
							}
						 })
						 SaveSelPropertyData(index,"selpro"+trId,"文本","","","remove")
						 SaveSelPropertyData(index,"selpro"+trId,"文本",Supplement,Supplement,"add") 
 						/*SaveSelPropertyData(index,"selpro"+trId,"文本","","","remove")
 						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=UpdateSupplement",   
							data:{
								"rowid":Rowid,     ///rowid
								"Supplement":Supplement
							},  
							type:"POST",   
							success: function(data){
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  	  //UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
									  	  SaveSelPropertyData(index,"selpro"+trId,"文本",Supplement,Supplement,"add")
									  } 
									  else { 
											var errorMsg ="补充诊断保存失败！"
											if (data.info) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.info
											}
											$.messager.alert('操作提示',errorMsg,"error");
									}			
							}  
						})*/
 				}
 			})
 			/*****************左侧属性快速检索列表结束*******************************************/
		}
		ChangePropertyShow("",indexTemplate);
	}

	//已选属性列表 右键复制按钮
	$("#CopySelPro").click(function (e) { 
		var aux=document.getElementById("Form_DiagPropertySelCopyText"); 
		aux.value=copytext; //赋值
		aux.select(); // 选择对象 
		document.execCommand("Copy"); // 执行浏览器复制命令 
	 })
	 //已选属性列表 右键删除按钮 取消勾选
	$("#DelSelPro").click(function (e) { 
		var record=$("#Form_DiagPropertySelectedGrid").datagrid("getSelected")
		var index=record.index;
		var trId=record.titleid
		var childDesc=record.title
		var id=record.id;
		var trids=record.titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
		var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
		var childId=trids.split("_")[1]
		var showtype=trids.split("_")[2];
		var childType=trids.split("_")[3];
		var treeNode=trids.split("_")[4];
		var isTOrP=trids.split("_")[5];
		if (showtype=="T"){ //树形
			if (childDesc=="文本"){
				//根据SDSRowId清空补充诊断
				// $.ajax({
				// 	url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrast&pClassMethod=UpdateSupplement",   
				// 	data:{
				// 		"rowid":$("#mygrid").datagrid("getSelected").Rowid,     ///rowid
				// 		"Supplement":""
				// 	},  
				// 	type:"POST",   
				// 	success: function(data){
				// 			  var data=eval('('+data+')'); 
				// 			  if (data.success == 'true') {
									//UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
								var MKBICDConSupplement = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()	
							  	  $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val("")
							  	  ifFirstLoadPropertyData=false;
							  	  SaveSelPropertyData(index,"selpro"+trId,childDesc,MKBICDConSupplement,"","remove")
				// 			  } 
				// 			  else { 
				// 					var errorMsg ="补充诊断保存失败！"
				// 					if (data.info) {
				// 						errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				// 					}
				// 					$.messager.alert('操作提示',errorMsg,"error");
				// 			}			
				// 	}  
				// })
			}else{
				var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',id); 
				$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node.target);
			}
		}
		if (showtype=="C"){ //下拉框
			$("#"+childId+"_C"+isTOrP+"").combobox('setValue', "");
		}
		if (showtype=="CB"){ //单选框
			$("#"+childId+"_"+id+"_CB"+isTOrP+"").prop('checked','');
			SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
		}
		if (showtype=="G"){ //列表3
			var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",id)
			$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
		}
		if (showtype=="CG"){ //多选框
			$("#"+childId+"_"+id+"_CG"+isTOrP+"").prop('checked','');
			SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
		}
	})
	function SpliceSelProperty(pindex,pid,type){
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				if (type=="add"){
					if(obj.id==""){ //清除标题行
						SelPropertyArr.splice(i,1)
					}
				}else{
					if (pid==""){ //清除所有
						SelPropertyArr.splice(i,1)
					}else{
						if (pid==obj.id){ //清除当前选中
							SelPropertyArr.splice(i,1)
						}
					}
				}
			}
		}
	}
	function GetSelPropertyNum(pindex){
		var num=0;
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				num++;	
			}
		}
		return num;
	}
	//属性列表勾选对已选列表赋值
	function SaveSelPropertyData(pindex,ptitleid,ptitle,pid,ptext,type){
		if(type=="add")
		{
	 	 	SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":ptext,"id":pid});
	 	 	SpliceSelProperty(pindex,pid,type);
	 	 	if((GetSelPropertyNum(pindex)==0)&&(pid=="")){
	 	 		SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
	 	 	}
	 	 	$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
		}
		if(type=="remove")
		{
			SpliceSelProperty(pindex,pid,type);
			if(GetSelPropertyNum(pindex)==0){
				SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
			}
			$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
		}
		if(indexTemplate!=undefined){
			//选中已选属性列表行
			var data=$('#Form_DiagPropertySelectedGrid').datagrid('getData')
			for (var i=0; i <data.rows.length; i++) { 
	 			if (data.rows[i]['titleid']=="selpro"+indexTemplate){
					$('#Form_DiagPropertySelectedGrid').datagrid('selectRow', i); //选中对应的行
					return;
				}
	 		}
		}else{
			$('#Form_DiagPropertySelectedGrid').datagrid('clearSelections')
		}
	}

	//仅显示已选择属性功能
	function ChangePropertyShow(showtypepara,indexTemplate){
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
					for (var k=0;k<unCheckedNodes.length;k++){
						var nodeId=unCheckedNodes[k].id;
						var node = $("#"+detailId+"").tree('find', nodeId);
						if (showtypepara=="on"){
	            			$("#"+node.target.id).css("display","none");
						}else{
	              			$("#"+node.target.id).css("display","");
						}
					}
					if (showtypepara=="on"){
						var CheckedNodes = $("#"+detailId+"").tree('getChecked');
						if (CheckedNodes.length==0){
							$("#"+trids).css("display","none");
						}else{
							$("#"+trids).css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="C"){
					var ComboData=$("#"+detailId+"").combobox('getValue');
					if (ComboData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="CB"){
					var Find=0;
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						if (!$("#"+radioId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+radioId+"").css("display","none");
								$("#"+radioId+"").next().css("display","none");
							}else{
								$("#"+radioId+"").css("display","");
								$("#"+radioId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="G"){ //列表3
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getChecked');
					if (GridData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="CG"){
					var Find=0;
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						if (!$("#"+checkboxId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+checkboxId+"").css("display","none");
								$("#"+checkboxId+"").next().css("display","none");
							}else{
								$("#"+checkboxId+"").css("display","");
								$("#"+checkboxId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				
			}
		}
	}
	
	//获取已选属性
	function GetSelectedPropertyStr(){
		var menuItemValueMap = {};
		var SelectedPropertyStr="";
		var SelectedPropertyDesc="";
		var SelectedPropertyName="";
		var Supplement=""
		var TreeCheckedIdStr=""
		var ComboCheckedIdStr=""
		var RadioCheckedIdStr=""
		var CheckBoxCheckedIdStr=""
		var GridCheckedIdStr=""//列表3
		var $dynamic_tr=$(".dynamic_tr");
		for (var i=0;i<($dynamic_tr.length);i++){
			(function(i){
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1];
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var tds=$("#"+trids+"").children();
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					if (showtype=="T"){
						if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
							var oneSelectedPropertyParentAll=""
							var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
							for (var k=0;k<treeCheckedIds.length;k++){
								var OneTreeCheckedId=treeCheckedIds[k].id;
								/*var oneTreeCheckedDesc=treeCheckedIds[k].target.innerText
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("^")[0]*/
								var oneTreeCheckedDesc=treeCheckedIds[k].text;
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("<span class='hidecls'>")[0];
								if (OneTreeCheckedId!=""){
									if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
									}else{
										var OneTreeCheckedIdItem=OneTreeCheckedId
									}
									if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
									else menuItemValueMap[childId]=OneTreeCheckedIdItem
								}
								if (TreeCheckedIdStr=="") TreeCheckedIdStr=OneTreeCheckedId
								else TreeCheckedIdStr=TreeCheckedIdStr+"&"+OneTreeCheckedId
								
							}
						}
					}
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						var ComboSelText=$("#"+detailId+"").combobox('getText');
						if (ComboSelId!=""){
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem
							if (ComboCheckedIdStr=="") ComboCheckedIdStr=ComboSelId
							else ComboCheckedIdStr=ComboCheckedIdStr+"&"+ComboSelId
						}
					}
					//列表3
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
								else menuItemValueMap[childId]=GridSelIdItem
								if (GridCheckedIdStr=="") GridCheckedIdStr=gridId
								else GridCheckedIdStr=GridCheckedIdStr+"&"+gridId
							}
						}
					}
					
					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var obj=$('input[name='+radioName+']:checked');
						var CheckedObj=obj[0];
						if(CheckedObj!=undefined){
							var CBSelId=CheckedObj.id.split("_")[1];
							var CBSelDesc=obj.next().text();
							if (CBSelId!=""){
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
								else menuItemValueMap[childId]=CBSelIdItem
								if (RadioCheckedIdStr=="") RadioCheckedIdStr=CBSelId
								else RadioCheckedIdStr=RadioCheckedIdStr+"&"+CBSelId
							}
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
								var CGSelId=CheckedObj[m].id.split("_")[1];
								var CGSelDesc=$("#"+CheckedObj[m].id+"").next().text();
								if (CGSelId!=""){
									if (childType=="S"){
										var CGSelIdItem="S"+CGSelId
									}else{
										var CGSelIdItem=CGSelId
									}
									if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
									else menuItemValueMap[childId]=CGSelIdItem
									if (CheckBoxCheckedIdStr=="") CheckBoxCheckedIdStr=CGSelId
									else CheckBoxCheckedIdStr=CheckBoxCheckedIdStr+"&"+CGSelId
								}
							}
						}
					}
				}
			})(i)
		}
	    for ( var mv in menuItemValueMap) {
		    if (SelectedPropertyStr=="") SelectedPropertyStr=mv+":"+menuItemValueMap[mv];
		    else SelectedPropertyStr=SelectedPropertyStr+","+mv+":"+menuItemValueMap[mv];
		}
		SelPropertyData=TreeCheckedIdStr+"^"+ComboCheckedIdStr+"^"+RadioCheckedIdStr+"^"+CheckBoxCheckedIdStr
		return SelectedPropertyStr;
	}
	function GetParamStr(termid){
		if (termid==""){
			var info=$("#SelMKBRowId").val();
		}else{
			var info=termid
		}
		if (info=="") return false;
		var newPropertyStr=""
		var SelectedPropertyStr=GetSelectedPropertyStr();
		for (var k=0;k<SelectedPropertyStr.split(",").length;k++){
			if (SelectedPropertyStr.split(",")[k]=="") continue;
			if (newPropertyStr=="") newPropertyStr=info+"-"+SelectedPropertyStr.split(",")[k];
			else newPropertyStr=newPropertyStr+","+SelectedPropertyStr.split(",")[k];
		}
		if (newPropertyStr=="") newPropertyStr=info;
		return newPropertyStr
	}
	//获取属性相关信息 ；flagFrequency：属性列表勾选是否记频次标识
	function GetPropertyValue(flagFrequency){
		GetSelectedPropertyStr();//石萧伟
		var menuItemValueMap = {};
		var TreeDataStr="";
		var ComboDataStr="";
		var RadioDataStr="";
		var CheckDataStr="";
		var DataStr="";
		var resultRequired="" //必填项未维护结果集
		var Supplement=""; //补充诊断
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			(function(i){
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var id=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1]; //属性id
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];//起始节点的id
				var isTOrP=trids.split("_")[5];//术语属性标识
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var ifRequired=$dynamic_tr[i].lang.split("_")[1] //是否必填项 //201917
				var tds=$("#"+trids+"").children();
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					if (showtype=="T"){
						if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
							//获取显示方式为树类型的选择节点串
							var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
							for (var k=0;k<treeCheckedIds.length;k++){
								var OneTreeCheckedId=treeCheckedIds[k].id;
								if (treeCheckedIds[k].text.indexOf("<span class='hidecls'>")>0){
									var OneText=treeCheckedIds[k].text.split("<span class='hidecls'>")[1].split("</span>")[0];
									var Onedisplayname=OneText.split("^")[2]; //展示名
								}else{
									var OneText=treeCheckedIds[k].text
								}
								if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
								}else{
									var OneTreeCheckedIdItem=OneTreeCheckedId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
								else menuItemValueMap[childId]=OneTreeCheckedIdItem
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var OneTreeCheckedDesc=treeCheckedIds[k].text.split("<span class='hidecls'>")[0]
									//DHCDocUseCount(trids+"#"+OneTreeCheckedId, OneTreeCheckedDesc,"User.SDSStructDiagnosProDetail"+id)
								}
							}
							if (treeCheckedIds==""){
								if (ifRequired=="Y"){
									//必填项未维护结果集
									if (resultRequired=="") resultRequired=childDesc
									else resultRequired=resultRequired+","+childDesc
								}
							}
						}
					}
					//列表3
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
								else menuItemValueMap[childId]=GridSelIdItem
							}

						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc	
							}
						}
					}				
					//下拉框
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						if ((ComboSelId!="")&(ComboSelId!=undefined)){
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
								var ComboSelDesc=$("#"+detailId+"").combobox('getText')
								//DHCDocUseCount(trids+"#"+ComboSelId, ComboSelDesc,"User.SDSStructDiagnosProDetail"+id)
							}
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc		
							}
						}
					}
					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var CheckedObj=$('input[name='+radioName+']:checked')[0];
						if(CheckedObj!=undefined){
							var CBSelId=CheckedObj.id.split("_")[1];
							if (CBSelId!=""){
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var CBSelDesc=$('input[name='+radioName+']:checked').next().text()
									//DHCDocUseCount(trids+"#"+CBSelId, CBSelDesc,"User.SDSStructDiagnosProDetail"+id)
								}
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
								else menuItemValueMap[childId]=CBSelIdItem
							}
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc		
							}
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
								var CGSelId=CheckedObj[m].id.split("_")[1];
								if (childType=="S"){
									var CGSelIdItem="S"+CGSelId
								}else{
									var CGSelIdItem=CGSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
								else menuItemValueMap[childId]=CGSelIdItem
							}
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
								$('input[name='+checkboxName+']:checked').each(function(n){
									var CGSelIdF=$('input[name='+checkboxName+']:checked')[n].id.split("_")[1]
									var CGSelDescF=$(this).next().text()
									//DHCDocUseCount(trids+"#"+CGSelIdF, CGSelDescF,"User.SDSStructDiagnosProDetail"+id)
								})
							}
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc	
							}
						}
					}
				}
			})(i)
		}
		for ( var mv in menuItemValueMap) {
		    if (DataStr=="") DataStr=mv+":"+menuItemValueMap[mv];
		    else DataStr=DataStr+","+mv+":"+menuItemValueMap[mv];
		}
		if (SelMRCICDRowid!=""){
			var DiagnosPropertyStr=SelMRCICDRowid+"#"+DataStr+"#"+Supplement+"#"+resultRequired;
		}else{
			var DiagnosPropertyStr="";
		}
		if (DiagnosPropertyStr=="") return "";
		return DiagnosPropertyStr;
	}
	
	//快速检索前台获取数据
	function DiagPropertySearch(SearchText,indexTemplate){
		CacheDiagPropertyICD={};
		CacheDiagPropertyICDNote={};
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1];
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			var PerfectMatchId="";
			var MatchNum=0;
			var PerfectMatchNum=0;
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					if (childDesc=="文本"){
						var TextStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocOtherTextDescStr",treeNode)
						if (TextStr!=""){
							var TextStrArr=TextStr.split("[A]");
							for (var k=0;k<TextStrArr.length;k++){
								var TextDetailId=TextStrArr[k].split("^")[0]
								var TextDetailDesc=TextStrArr[k].split("^")[1]
								if(TextDetailDesc != undefined){//石萧伟加判断
									if (TextDetailDesc.indexOf(SearchText)>=0){
										CacheDiagPropertyICD[trids+"#"+TextDetailId]=TextDetailDesc; //cache
									}
								}
							}
						}
					}else{
						$("#"+detailId+"").tree("search",trids+"^"+SearchText)
						//检索码>展示名>分型描述>别名 【模糊查找】  查找优先级
						//var treeData=$("#"+detailId+"").tree("options").data;
					}
				}
				if (showtype=="C"){
					var ComboData=$("#"+detailId+"").combobox('getData');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTPDRowId;
							var ComboText=ComboData[k].comDesc; //TKBTDDesc
		          			var ComboPYText=ComboData[k].PYDesc.toUpperCase(); //20180315bygss
							var ComboRemark=ComboData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if ((ComboText.indexOf(SearchText)>=0)||(ComboPYText.indexOf(SearchText)>=0)){
									//鼠标悬浮显示备注
									/*if (ComboRemark!=""){
										CacheDiagPropertyICD[trids+"#"+ComboId]='<span class="hisui-tooltip" title="'+ComboRemark+'">'+ComboText+'</span>'//ComboText; //cache
									}else{
										CacheDiagPropertyICD[trids+"#"+ComboId]=ComboText; //cache
									}*/
									CacheDiagPropertyICD[trids+"#"+ComboId]=ComboText; //cache
									if (ComboRemark!=""){
										CacheDiagPropertyICDNote[trids+"#"+ComboId]=ComboRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{//检索条件为空
								CacheDiagPropertyICD[trids+"#"+ComboId]=ComboText; //cache
								if (ComboRemark!=""){
									CacheDiagPropertyICDNote[trids+"#"+ComboId]=ComboRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTRowId ;
							var ComboText=ComboData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (ComboText.indexOf(SearchText)>=0){
									CacheDiagPropertyICD[trids+"#"+ComboId]=ComboText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{
								CacheDiagPropertyICD[trids+"#"+ComboId]=ComboText; //cache
							}
						}
					}
				}
				//单选框
				if (showtype=="CB"){
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						var radioText=$("#"+radioId+"").next()[0].innerText;
						if (SearchText!=""){
							if (radioText.indexOf(SearchText)>=0){
								CacheDiagPropertyICD[trids+"#"+radioId.split("_")[1]]=radioText; //cache
								PerfectMatchNum=PerfectMatchNum+1;
							}else{
								/*$("#"+radioId+"").css("display","none");
								$("#"+radioId+"").next().css("display","none");*/
							}
							if (SearchText==radioText){
								PerfectMatchId=radioId;
							}
							/*if (PerfectMatchId!=""){
								$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									$("#"+trids+"").css("display","none");
								}
							}*/
						}else{//检索条件为空
							CacheDiagPropertyICD[trids+"#"+radioId.split("_")[1]]=radioText; //cache
							/*$("#"+radioId+"").css("display","");
						    $("#"+radioId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
				//列表3
				if (showtype=="G"){
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getRows');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTPDRowId;
							var GridText=GridData[k].comDesc; //TKBTDDesc
		          			var GridPYText=GridData[k].PYDesc.toUpperCase(); //20180315bygss
							var GridRemark=GridData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if ((GridText.indexOf(SearchText)>=0)||(GridPYText.indexOf(SearchText)>=0)){
									CacheDiagPropertyICD[trids+"#"+GridId]=GridText; //cache
									if (GridRemark!=""){
										CacheDiagPropertyICDNote[trids+"#"+GridId]=GridRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{//检索条件为空
								CacheDiagPropertyICD[trids+"#"+GridId]=GridText; //cache
								if (GridRemark!=""){
									CacheDiagPropertyICDNote[trids+"#"+GridId]=GridRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTRowId ;
							var GridText=GridData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (GridText.indexOf(SearchText)>=0){
									CacheDiagPropertyICD[trids+"#"+GridId]=GridText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{
								CacheDiagPropertyICD[trids+"#"+GridId]=GridText; //cache
							}
						}
					}
				}

				//多选框
				if (showtype=="CG"){
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						var checkboxText=$("#"+checkboxId+"").next()[0].innerText;
						if (SearchText!=""){
							if (checkboxText.indexOf(SearchText)>=0){
								CacheDiagPropertyICD[trids+"#"+checkboxId.split("_")[1]]=checkboxText; //cache
								PerfectMatchNum=PerfectMatchNum+1;
							}else{
								/*$("#"+checkboxId+"").css("display","none");
								$("#"+checkboxId+"").next().css("display","none");*/
							}
							if (SearchText==checkboxText){
								PerfectMatchId=checkboxId;
							}
							if (PerfectMatchId!=""){
								//$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									//$("#"+trids+"").css("display","none");
								}
							}
						}else{//检索条件为空
							CacheDiagPropertyICD[trids+"#"+checkboxId.split("_")[1]]=checkboxText;
							/*$("#"+checkboxId+"").css("display","");
						    $("#"+checkboxId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
			}
		}
		if (SearchText==""){
			//$("tr[id*='_']").css("display","table-row");
		}else{
			//$("tr[id*='_']").css("display","none");
		}
		/*if(sum==$dynamic_tr.length){
			return true
		}else{
			return false
		}*/
	}
	
/** 
 * 1）扩展jquery hisui tree的节点检索方法。使用方法如下： 
 * $("#treeId").tree("search", searchText);   
 * 其中，treeId为hisui tree的根UL元素的ID，searchText为检索的文本。 
 * 如果searchText为空或""，将恢复展示所有节点为正常状态 
 */ 
	$.extend($.fn.tree.methods, {  
        /** 
         * 扩展hisui tree的搜索方法 
         * @param tree hisui tree的根DOM节点(UL节点)的jQuery对象 
         * @param searchText 检索的文本 
         * @param this-context hisui tree的tree对象  trids+"^"+SearchText
         */  
        search: function(jqTree, str) {
	        var trids=str.split("^")[0];
	        var searchText=str.split("^")[1];
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
            //如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText);  
            /*if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show(); 
                    tree.collapse(jqTree, nodeList[i].target); 
                }  
                //展开已选择的节点（如果之前选择了）  
                var selectedNode = tree.getChecked(jqTree);  
                if (selectedNode) { 
                	for (var i=0;i<selectedNode.length;i++){
	                	 tree.expandTo(jqTree, selectedNode[i].target);  //
	                }
                }
                return;  
            } **/
            //搜索匹配的节点并高亮显示  
            var matchedNodeList = []; 
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];  
                   	if(searchText!=""){
	                    if (isMatch(searchText, node.text)) {  
	                        //matchedNodeList.push(node);  
	                        var text=node.text.split("<span class='hidecls'>")[0];
	                    	//20180317bygss 鼠标悬浮显示备注
	                        var remark=node.text.split("^")[3].split("</span>")[0]
	                        /*if (remark!=""){
	                        	CacheDiagPropertyICD[trids+"#"+node["id"]]='<span class="hisui-tooltip" title="'+remark+'">'+text+'</span>' //text; //cache
	                        }else{
	                        	CacheDiagPropertyICD[trids+"#"+node["id"]]=text; //cache
	                        }*/
	                        CacheDiagPropertyICD[trids+"#"+node["id"]]=text; //cache
	                        if (remark!=""){
	                        	CacheDiagPropertyICDNote[trids+"#"+node["id"]]=remark; //cache
	                        }
	                    } 
                   	}else{//检索条件为空
                   		var text=node.text.split("<span class='hidecls'>")[0];
                        var remark=node.text.split("^")[3].split("</span>")[0]
                        CacheDiagPropertyICD[trids+"#"+node["id"]]=text; //cache
                        if (remark!=""){
                        	CacheDiagPropertyICDNote[trids+"#"+node["id"]]=remark; //cache
                        }
                   	}
                }  
                  
                //隐藏所有节点  
                /*for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                //折叠所有节点  
                tree.collapseAll(jqTree);  
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                } */ 
            }      
        },  
        /** 
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了） 
         * @param node hisui tree节点 
         */  
        showChildren: function(jqTree, node) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //展示子节点  
            if (!tree.isLeaf(jqTree, node.target)) {  
                var children = tree.getChildren(jqTree, node.target);  
                if (children && children.length>0) {  
                    for (var i=0; i<children.length; i++) {  
                        if ($(children[i].target).is(":hidden")) {  
                            $(children[i].target).show();  
                        }  
                    }  
                }  
            }     
        },  
        /** 
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
         * @param param { 
         *    treeContainer: hisui tree的容器（即存在滚动条的树容器）。如果为null，则取hisui tree的根UL节点的父节点。 
         *    targetNode:  将要滚动到的hisui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //如果node为空，则获取当前选中的node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);  
              
            if (targetNode != null) {  
                //判断节点是否在可视区域                 
                var root = tree.getRoot(jqTree);  
                var $targetNode = $(targetNode.target);  
                var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();  
                var containerH = container.height();  
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;  
                if (nodeOffsetHeight > (containerH - 30)) {  
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;  
                    container.scrollTop(scrollHeight);  
                }                             
            }  
        }  
    });  
    /** 
     * 展示搜索匹配的节点 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //展示所有父节点  
        $(node.target).show();  
        //return false;
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //展开到该节点  
        tree.expandTo(jqTree, node.target);  
        //如果是非叶子节点，需折叠该节点的所有子节点  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
    /** 
     * 判断searchText是否与targetText匹配 
     * @param searchText 检索的文本 
     * @param targetText 目标文本 
     * @return true-检索的文本与目标文本匹配；否则为false. 
     */  
    function isMatch(searchText, targetText) {
	    searchText=searchText.toUpperCase() ;
    	var text=targetText.split("<span class='hidecls'>")[0];
    	var text2=targetText.split("<span class='hidecls'>")[1];
    	if (text2!=""){
	    	var tmpsearchtext=text2.split("</span>")[0];
			var searchCode=tmpsearchtext.split("^")[1]; //检索码
			var othername=tmpsearchtext.split("^")[0]; //别名
			var displayname=tmpsearchtext.split("^")[2]; //展示名
			
			return $.trim(text)!="" && (text.toUpperCase().indexOf(searchText)!=-1 || searchCode.toUpperCase().indexOf(searchText)!=-1 ||othername.toUpperCase().indexOf(searchText)!=-1 || displayname.toUpperCase().indexOf(searchText)!=-1)  
	    }else{
		    return $.trim(text)!="" && text.indexOf(searchText)!=-1;  
		}
    }  
    /** 
     * 获取hisui tree的所有node节点 
     */  
    function getAllNodes(jqTree, tree) {  
        var allNodeList = jqTree.data("allNodeList");  
        if (!allNodeList) {  
            var roots = tree.getRoots(jqTree);  
            allNodeList = getChildNodeList(jqTree, tree, roots);  
            jqTree.data("allNodeList", allNodeList);  
        }  
        return allNodeList;  
    } 
    /** 
     * 定义获取hisui tree的子节点的递归算法 
     */  
    function getChildNodeList(jqTree, tree, nodes) {  
        var childNodeList = [];  
        if (nodes && nodes.length>0) {             
            var node = null;  
            for (var i=0; i<nodes.length; i++) {  
                node = nodes[i];  
                childNodeList.push(node);  
                if (!tree.isLeaf(jqTree, node.target)) {  
                    var children = tree.getChildren(jqTree, node.target);  
                    childNodeList = childNodeList.concat(getChildNodeList(jqTree, tree, children));  
                }  
            }  
        }  
        return childNodeList;  
    }  
    
    // 扩展datagrid:动态添加删除editor  
	$.extend($.fn.datagrid.methods, {  
	    addEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item.field);  
	                e.editor = item.editor;  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param.field);  
	            e.editor = param.editor;  
	        }  
	    },  
	    removeEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item);  
	                e.editor = {};  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param);  
	            e.editor = {};  
	        }  
	    }  
	});  
    
	
	/******************************属性列表功能结束**************************************************************/
    //提交按钮
    $('#commitbtn').click(function(e){
        updataResult(2);

    });
    //修改按钮
    $('#updataResultBtn').click(function(e){
        updataResult(1);

    });
    //提交和修改方法
    updataResult=function(flag){		
        //GetSelectedPropertyStr();
        var propertyValue = GetPropertyValue("1");
        //UpdateName(propertyValue);
        var record = $("#leftgrid").datagrid("getSelected");
        if(record)
        {
            var rowid = record.Rowid;
            var MKBICDConTermDr =propertyValue.split("#")[0];
            var MKBICDConResultID = propertyValue.split('#')[1];
            var MKBICDConResult = ""//.replace(/\(.*?\)/g,'');
			var MKBICDConSupplement = propertyValue.split('#')[2]
			var termidforjust=$('#combogrid').combogrid('getValue')
			if (termidforjust==""||termidforjust==undefined){
				$.messager.alert('错误提示','诊断不能为空!',"error");
				return;
			}
			//判断获取到的下拉框的值是否正确，防止保存上一条记录的数据
			var IdExsit=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justIdExist",termidforjust);
			if(termidforjust != "" && IdExsit==""){
				$.messager.alert('错误提示','请在下拉框选择一条正确的诊断!',"error");
				return;
			}			
            if(flag == 1) {
                var cord=$("#mygrid").datagrid("getSelected");
                if(cord){
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",rowid,cord.Rowid,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					firstflag = "up";//判断是否是默认加载第一项的标志
					firstid = data.id;//保存操作项id				
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
                }else{
                        $.messager.alert('错误提示','请先选中一条诊断!',"error");
				} 
            } else if(flag == 2){
                //如果是新增要判断有没有同名诊断
                var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","justHasExist",rowid,MKBICDConTermDr);
                if(existStr != ""){ 
					$("#xWin").show();
					$("#xWin").html("")
					$("#xWin").append('已经存在同名诊断<font color=red>'+ existStr.split('^')[1]+'</font>确定要替换吗?')
					var myWin = $HUI.dialog("#xWin",{
						resizable:true,
						title:'同名诊断',
						modal:true,
						buttonAlign : 'center',
						buttons:[{
							text:'替换',
							id:'save_btn',
							handler:function(){
								var childId = existStr.split('^')[0]; 
								var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",rowid,childId,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
								var data=eval('('+result+')');
								firstflag = "up";//判断是否是默认加载第一项的标志
								firstid = data.id;//保存操作项id							
								if(data.success == 'true'){
									refreshResultcolumn();//刷新左侧结构化字段
								}
								$('#mygrid').datagrid('load',  { 
									ClassName:"web.DHCBL.MKB.MKBICDContrast",
									QueryName:"GetResultList",
									id:record.Rowid
								}); 
								$('#xWin').window('close');
							}
						},{
							text:'新增',
							handler:function(){
								var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",rowid,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
								var data=eval('('+result+')');
								firstflag = "up";//判断是否是默认加载第一项的标志
								firstid = data.id;//保存操作项id							
								if(data.success == 'true'){
									refreshResultcolumn();//刷新左侧结构化字段
								}
								$('#mygrid').datagrid('load',  { 
									ClassName:"web.DHCBL.MKB.MKBICDContrast",
									QueryName:"GetResultList",
									id:record.Rowid
								}); 
								$('#xWin').window('close');
							}
						}]
					});						
                } else{
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","SaveData",rowid,"",MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement);
					var data=eval('('+result+')');
					firstflag = "up";//判断是否是默认加载第一项的标志
					firstid = data.id;//保存操作项id				
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
                }              
                     
            }         
                              

            //$('#leftgrid').datagrid('reload'); //刷新列表
            $('#mygrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetResultList",
                id:record.Rowid
            });            
           //刷新右侧数据
            setTimeout(function(){
                //refreshRightPanel();
            },500) 
        }else{
            $.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
        }       
    }
    //点击提交后刷新右侧数据
    refreshRightPanel=function(){
		PreSearchText = "";//清空检索框   石萧伟20190827
        var record=$("#mygrid").datagrid("getSelected");
        var ccc=$('#combogrid')

        if(record.MKBICDConTermDr != ""){

            //按照第一个诊断模板加载
            /*if(record.MKBICDConTermDr.indexOf("And")>0){
                var proId = record.MKBICDConTermDr.split("And")[0];
                var termid=tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","GetTermIdByProId",proId);
                var termDesc = ((record.MKBICDConResult).split('And')[0]).split("[")[0];
            }else{*/
                var termid=record.MKBICDConTermDr
				var termDesc =""
				var desc2 = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","findTermDescById",termid); 
				if(desc2 != ""){
					termDesc = desc2
				}else{
					termDesc = (record.MKBICDConResult).split("[")[0];
				}
            //}
            //alert(termDesc+"*"+termid)
            CreatPropertyDom("",termid,record.Rowid,"");   
            LoadDiagnosData(termDesc,ccc);//加载诊断下拉框
            $('#combogrid').combogrid('setValue',termid);                    
            setTimeout(function(){
            //诊断列表有选中时，才允许弹出属性列表
                findCondition = "" ; 
            },50)    
            
            //
            //去掉<font>
            /*var reg1=new RegExp("<font>","g"); //创建正则RegExp对象 
            var newstr = record.MKBICDConResult  
            newstr=newstr.replace(reg1,"");
            var reg2=new RegExp("</font>","g"); //创建正则RegExp对象 
            newstr=newstr.replace(reg2,"");
            //$('#SDSViewId').text('结构化结果描述:'+newstr)
            //
            var newstr = record.MKBICDConResult  */
            SelMRCICDRowid = termid
            //
            //$('.view1').remove();
            //var p1 = '<font color=red class="view1">结构化结果:&nbsp&nbsp'+newstr+'</font>'
            //$('#SDSViewId').append(p1)

        }/*else if(record.MKBICDCenterWord != "" && record.MKBICDConTermDr == ""){
            var termDesc = (record.MKBICDCenterWord).split(",")[0];
            var termid = (record.MKBICDCenterWordID).split(",")[0];
            SelMRCICDRowid = termid
            CreatPropertyDom("","",termid,"","");  
            LoadDiagnosData(termDesc,ccc);
            $('#combogrid').combogrid('setValue',termid); 
            //$('.view1').remove();
        }else if(record.MKBICDCenterWord == "" && record.MKBICDConTermDr == ""){
            $('#combogrid').combogrid('setValue',''); 
            //$('.view1').remove();
        }
        


        /*$('.view2').remove();
        var p2 = '<font color=red class="view2">&nbsp&nbsp'+record.MKBICDDesc+'</font>'
        $('#termViewId').append(p2);
        //分词显示
        $('.trView').remove();
        var trViewArr = (record.MKBICDConSegmentation).split(';')
        for(var i=0; i<trViewArr.length; i++)
        {
            $('#trViewId').append('<font color=redgreen class="trView">&nbsp&nbsp'+trViewArr[i]+'</font>')
        }    */  

    }

    ///知识点按钮
    $("#btnTerm").click(function (e) { 
        var termid=$('#combogrid').combogrid('getValue')
        /*var height=parseInt(window.screen.height)-120;
        var width=parseInt(window.screen.width)-50;
        var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+termid+"&ProId="; 
		window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)*/
		

		var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
		var parentid=""//tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
		var menuimg=""//tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
		//判断浏览器版本
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		//双击时跳转到对应界面
		if(!Sys.ie){
			window.parent.closeNavTab(menuid)
			window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",parentid,menuimg)
		}else{
			parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",menuimg);
		}
	});
	
	/************************************************上报审核功能开始******************************************************* */	

	$('#reviewed_data').click(function(e){
		$('#reviewed_Data_Div').show();
		var reviewedDiv = $HUI.dialog("#reviewed_Data_Div",{
            iconCls:'icon-w-paper',
            resizable:true,
			title:'上报待审核数据',
			width:$(window).width()*9/10,
			height:$(window).height()*9/10,
			modal:true

		});	
	})
    var reviewedcolumns =[[ 
		{field:'MKBDRRowId',title:'rowid',hidden:true,sortable:true,width:100},
		{field:'MKBDRDiagDr',title:'诊断dr',hidden:true,sortable:true,width:100},
		{field:'MKBDRDiagDesc',title:'原诊断名',sortable:true,width:100,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
		{field:'MKBDRStructChild',title:'结构化诊断第一条',sortable:true,width:100,hidden:true},
		{field:'MKBDRDiag',title:'上报诊断名',sortable:true,width:100,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
		{field:'MKBDRTermDR',title:'termdr',sortable:true,width:100,hidden:true},
		{field:'MKBDRStructResultID',title:'结构化结果id',sortable:true,width:100,hidden:true},
		{field:'MKBDRStructDesc',title:'结构化结果',sortable:true,width:130,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}	
		},
		{field:'MKBDRSupplement',title:'补充诊断',sortable:true,width:100,hidden:true},
		{field:'MKBDRMRCDr',title:'icddr',sortable:true,width:100,hidden:true},
		{field:'MKBDRMRCCode',title:'ICD编码',sortable:true,width:70,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
		{field:'MKBDRMRCDesc',title:'ICD描述',sortable:true,width:70,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			},hidden:true
		},
		{field:'MKBDRICDDesc',title:'ICD描述',sortable:true,width:70,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}	
		},
		{field:'MKBDRReson',title:'上报理由',sortable:true,width:100,
			formatter:function(value,row,index){
				var str=value.replace(/,/g,"\n")
				var content = '<span href="#" title="' + str + '" class="mytooltip">' + value + '</span>';
				return content;
			}		
		},
		{field:'MKBDRNote',title:'备注',sortable:true,width:80},
		{field:'MKBDRStatus',title:'审核状态',sortable:true,width:40,
			formatter:function(value,row,index){
				if(value=="N"){
					return "<font color=red>未审核</font>"
				}else{
					return "<font color=green>已审核</font>"
				}
			}
		},
		{field:'MKBDROtherDesc',title:'其他描述',sortable:true,width:100,hidden:true},
		{field:'MKBDRResonValue',title:'理由id',sortable:true,width:100,hidden:true},
		{field:'MKBDRMRADMDR',title:'admdr',sortable:true,width:100,hidden:true}
		]];
		var mygrid = $HUI.datagrid("#reviewed_grid",{
		url:$URL,
		queryParams:{
		ClassName:"web.DHCBL.MKB.MKBDataReviewed",
		QueryName:"GetList",
		type:"ICD"
		},
		columns: reviewedcolumns,  //列信息
		pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBDRRowId',
		ClassTableName:'User.MKBDataReviewed',
		SQLTableName:'MKB_DataReviewed', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//scrollbarSize :15,
		remoteSort:false,
		//sortName:'MKBKMRowId',
		//sortOrder:'desc',
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			return "<div style='width:99%;height:420px;'><iframe id='i"+rowData.MKBDRRowId+"' class='myiframe' frameborder='0' src='' style='width:97%;height:95%;'></iframe></div>";
		},
		onExpandRow:function(rowIndex,rowData){
			/*var expannummax=0,expannummin=0
			 $.each($('.datagrid-row-collapse'),function(i,r){
				   var ids= $(this).parent().parent().parent().attr('datagrid-row-index');
				   if ((ids<rowIndex)&(rowData.MKBTPDDescCount>3)){
						   expannummax=expannummax+1
				   }
				   else if((ids<rowIndex)&(rowData.MKBTPDDescCount<=3)){
						   expannummin=expannummin+1
				   }
			});*/
			$('#reviewed_grid').datagrid('selectRow',rowIndex)
			var scrollheight=rowIndex*35;  
			
			$(this).prev().find('div.datagrid-body').prop('scrollTop',scrollheight);
			//mradm^短语dr^短语描述(或简拼)^Termdr^ResultID^补充诊断^ICDDr^ICD代码^ICD描述^结构化诊断描述
			var id=rowData.MKBDRRowId;
			var status = rowData.MKBDRStatus;
			var SDSStr = rowData.MKBDRMRADMDR+"^"+rowData.MKBDRDiagDr+"^"+rowData.MKBDRDiag+"^"+rowData.MKBDRTermDR+"^"+rowData.MKBDRStructResultID+"^"+rowData.MKBDRSupplement+"^"+rowData.MKBDRMRCDr+"^"+rowData.MKBDRMRCCode+"^"+rowData.MKBDRICDDesc+"^"+rowData.MKBDRStructDesc+"^"+rowData.MKBDROtherDesc+"^ICD"
			//var SDSStr="460^4268^2xtnb^^^^3^E111^糖糖^"
			//alert(rowData.MKBDRStructChild.split("||")[1])
			if(rowData.MKBDRStructChild.split("||")[1]==""){
				var SDchild = ""	
			}else{
				var SDchild = rowData.MKBDRStructChild
			}
			contenturl="dhc.bdp.mkb.mkbdataexamine.csp?SDSStr="+encodeURI(SDSStr)+"&SDnote="+rowData.MKBDRNote+"&SDreason="+encodeURI(rowData.MKBDRResonValue)+"&SDid="+id+"&SDstatus="+encodeURI(status)+"&SDchild="+encodeURI(SDchild)+"&SDrowIndex="+rowIndex;
			$('#i'+id).attr('src',contenturl)
		
		},
		onCollapseRow:function(rowIndex,rowData){
			//收缩时刷新内容单元格
			$('#reviewed_grid').datagrid('reload')
		},		
		onClickRow:function(index,row)
		{

		},
		onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$(this).datagrid('columnMoving');
		},
        onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmmm = $('<div style="width:150px;"></div>').appendTo('body');
            $(
				'<div onclick="DeleteRewData()" iconCls="icon-cancel" data-options="">删除</div>'
            ).appendTo(mygridmmm)
            mygridmmm.menu()
            mygridmmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        }	
	});
	DeleteRewData=function(){
		var record=$('#reviewed_grid').datagrid('getSelected');
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.MKBDRRowId;
				$.ajax({
					url:"./dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=DeleteRewData",
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#reviewed_grid').datagrid('reload');
							$('#reviewed_grid').datagrid('unselectAll');
						}
						else{
							var errorMsg="删除失败！";
							if(data.info){
								errorMsg=errorMsg+'</br>错误信息:'+data.info
							}
							$.messager.alert('错误提示',errorMsg,'error')
						}
					}
				});
			}
		});
	}	
	//上报理由查询框
	$("#TextReviewed_Reason").combobox({
		valueField:'id',
		textField:'text',
		panelWidth:230,
		data:[
			{id:'',text:'全部'},
			{id:'A',text:'缺诊断短语'},
			{id:'B',text:'诊断短语不正确'},
			{id:'C',text:'缺诊断表达式'},
			{id:'D',text:'诊断表达式不正确'},
			{id:'E',text:'缺ICD'},
			{id:'F',text:'ICD不正确'}
			
		],
		value:'',
		onSelect: function(record){
			searchReviewedData();
		}
	})
	//审核状态
	$("#TextReviewed_State").combobox({
		valueField:'id',
		textField:'text',
		panelWidth:230,
		data:[
			{id:'',text:'全部'},
			{id:'Y',text:'已审核'},
			{id:'N',text:'未审核'}			
		],
		value:'',
		onSelect: function(record){
			searchReviewedData();
		}
	})
	//搜索回车事件
	$('#TextReviewed_Dia').keyup(function(event){
		if(event.keyCode == 13) {
			searchReviewedData();
		}
	}); 	
	
	searchReviewedData = function(){
		var desc = $('#TextReviewed_Dia').val()
		var reason = $('#TextReviewed_Reason').combobox('getValue')
		var status = $('#TextReviewed_State').combobox('getValue')
		$('#reviewed_grid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBDataReviewed",
			QueryName:"GetList",
			desc:desc,
			reason:reason,
			status:status,
			type:"ICD"
		});  
		$('#reviewed_grid').datagrid('unselectAll')   

	}
	$('#reviewed_dia_search').click(function(e){
		searchReviewedData();
	})
	$('#reviewed_dia_refresh').click(function(e){
		$('#TextReviewed_Dia').val('')
		$('#TextReviewed_Reason').combobox('setValue','')
		$('#TextReviewed_State').combobox('setValue','')
		$('#reviewed_grid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBDataReviewed",
			QueryName:"GetList",
			type:"ICD"
		});  
		$('#reviewed_grid').datagrid('unselectAll')   

	})
	/************************************************上报审核功能结束******************************************************* */	
	
/************************************************页面跳转与普通加载**************************************************/
    //页面跳转与普通加载
    if(jumpflag != ""){//二厂跳过来
        if(jumpflag == 1){//结构化完全相同结果
            options={};
            options.url=$URL;
            options.queryParams={
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetSameStructResult",
                ids:jumpids,
                termdr:jumptermdr,
                supplement:jumpSupplement,
                source:ICDSource
                //basedr:STBBase
            }
        }else{//结构化包含查询内容
            options={};
            options.url=$URL;
            options.queryParams={
                ClassName:"web.DHCBL.MKB.MKBICDContrast",
                QueryName:"GetNotSameIdsButSameItem",
                ids:jumpids,
                termdr:jumptermdr,
                supplement:jumpSupplement,
                source:ICDSource
                //basedr:STBBase
            }           
        }
        $('#TextEdition').combobox('setValue',ICDSource);
        $('#leftgrid').datagrid(options);
        $("#leftgrid").datagrid('unselectAll');

    }else{//点击菜单打开对应页面
        options={};
        options.url=$URL;
        options.queryParams={
            ClassName:"web.DHCBL.MKB.MKBICDContrast",
            MethodName:"GetNewList",
            //loc:"心内科",
            //status:"N"//默认显示未处理
            sort:0,//默认按科室总频次排序
            match:"A",
            source:defaultflag
        }
        $('#leftgrid').datagrid(options);
        $("#leftgrid").datagrid('unselectAll');         
    }

 /************************************************页面跳转与普通加载结束**************************************************/

    //导出实际匹配结果按钮
    $('#onload_btn').click(function(e){
        loadData();
    })

    loadData = function(){
        $(".load").attr("href","#");
        $(".load").removeAttr("download");
        $(".load").removeAttr("target");
        //win10不支持
        var os = navigator.platform;  
        var userAgent = navigator.userAgent;
        if (os.indexOf("Win") > -1) { 
            /*if (userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1) {  
                console.log("Win7");  
            } else */
            if (userAgent.indexOf("Windows NT 6.2") > -1 && userAgent.indexOf("Windows 8") > -1) {  
                $.messager.alert('错误提示','该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!',"error");
                return; 
            } else if (userAgent.indexOf("Windows NT 6.3") > -1 && userAgent.indexOf("Windows 8.1") > -1) {  
                $.messager.alert('错误提示','该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!',"error");
                return; 
            } else if (userAgent.indexOf("Windows NT 10.0") > -1 && userAgent.indexOf("Windows 10") > -1) {  
                $.messager.alert('错误提示','该功能不支持win10系统在ie下导出，请使用谷歌浏览器!',"error");
                return; 
            }   
        }
        var EXPORT_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDContrastInterface&pClassMethod=ExportICDResult";
        var ICDEdition=$('#TextEdition').combobox('getValue'); //获得ICD版本id
        /*fileName =tkMakeServerCall("web.DHCBL.MKB.MKBICDContrastInterface","ExportICDResult",ICDEdition);
        filepath ="../scripts/bdp/MKB/DataExport/"+fileName;
        $(".load").attr("href",filepath);
        $(".load").attr("download",fileName);
        //alert(filepath);
        //判断浏览器是否支持a标签 download属性
        var isSupportDownload = 'download' in document.createElement('a');
        if(isSupportDownload){
            var fileType = fileName.split(".")[fileName.split(".").length-1];
            if((fileType!="pdf")&&(fileType!="PDF")){
                objIframe=document.createElement("IFRAME");
                document.body.insertBefore(objIframe);
                objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
                pic   =   window.open($(".load").attr("href"),"a1");
                document.all.a1.removeNode(true)
            }else{
                alert("此浏览器使用另存下载");
                $(".load").attr("target","_blank");    
            }   
        }  */
        $.ajax({
            url:EXPORT_ACTION_URL,  
            data:{"ICDDiaSource":ICDEdition},  
            type:"POST",  
            //dataType : "json",
            //dataType:"TEXT", 
            success: function(data)
            {       
                var data=eval('('+data+')'); //解析json方式一
                //var data = JSON.parse(data); //解析json方式二
                if (data.fileName != "") 
                var fileName=data.fileName;      
                //var fileName="数据处理工厂数据对应MRC的ICD和描述.csv";   
                if(fileName!=""){             
                    filepath ="../scripts/bdp/MKB/DataExport/"+fileName;
                    $(".load").attr("href",filepath);
                    $(".load").attr("download",fileName);
                    //alert(filepath);
                    //判断浏览器是否支持a标签 download属性
                    var isSupportDownload = 'download' in document.createElement('a');
                    if(isSupportDownload){
                        var fileType = fileName.split(".")[fileName.split(".").length-1];
                        if((fileType!="pdf")&&(fileType!="PDF")){
                            objIframe=document.createElement("IFRAME"); //创建元素
                            var list=document.getElementById("insert");
                            var load=document.getElementById("onload_btn"); //获取节点
                            //document.body.insertBefore(objIframe,load);
                            list.insertBefore(objIframe,load);
                            objIframe.outerHTML=   "<iframe   name=a1 id = 'a1' style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
    						pic = window.open($(".load").attr("href"),"a1");
    						//objIframe.removeNode(true);
    						setTimeout(function(){
    							//var elem=document.getElementById('a1'); // 按 id 获取要删除的元素
    							//list.removeChild(elem); // 让  “父元素” 删除 “要删除的元素”
                                $('#a1').remove(); //方法二
    						},2000)
                        }else{
                            alert("此浏览器使用另存下载");
                            $(".load").attr("target","_blank");
                        }
                    }
                }else{
                    $.messager.alert("提示","导出失败","error")
                    //$.messager.progress('close');
                }
            }  
        })         
    }

    $('#pre_btn').click(function (e){
        previewStruct();
    });

    previewStruct=function()
    {
        var record = $('#leftgrid').datagrid('getSelected');
        //alert(1);
        if(record)
        {
            var record1 = $("#mygrid").datagrid("getSelected");
            if(record1)
            {
                var termid = record1.MKBICDConTermDr; //中心词id
                var parid = record.Rowid;
                var rowid = record1.Rowid; //子表id
                var url="../csp/dhc.bdp.mkb.mkbopeconpre.csp?termid="+termid+"&parid="+parid+"&rowid="+rowid
                if ('undefined'!==typeof websys_getMWToken){
					url += "&MWToken="+websys_getMWToken()
				}
                var myWinPreStruct=$HUI.window("#myWinPre",{
                    closable:true,
                    resizable:true,
                    width:$(window).width()*9/10, //不含滚动条，浏览器的宽度
                    height:$(window).height()*9/10,
                    collapsible:false,
                    minimizable:false,
                    title:'预览',
                    modal:true,   
                    content:'<iframe frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
                });
                $("#myWinPre").show();
            }
            else
            {
                $.messager.alert('提示','请先选中已结构化的记录!',"error");
                return; 
            }
        }
        else
        {
            $.messager.alert('提示','请先选中一条记录再进行设置!',"error");
            return; 
        }
        
    }

/********************************************导出左侧列表的数据************************************************************* */
	//导出实际匹配结果按钮
	$('#onloaddata_btn').click(function(e){
		loadLeftData();
	})
	//点击导出实际匹配结果按钮
    function loadLeftData()
    {	
		//win10不支持
		var os = navigator.platform;  
		var userAgent = navigator.userAgent;
		if (os.indexOf("Win") > -1) { 
			/*if (userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1) {  
				console.log("Win7");  
			} else */
			if (userAgent.indexOf("Windows NT 6.2") > -1 && userAgent.indexOf("Windows 8") > -1) {  
				$.messager.alert('错误提示','该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!',"error");
				return;	
			} else if (userAgent.indexOf("Windows NT 6.3") > -1 && userAgent.indexOf("Windows 8.1") > -1) {  
				$.messager.alert('错误提示','该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!',"error");
				return;	
			} else if (userAgent.indexOf("Windows NT 10.0") > -1 && userAgent.indexOf("Windows 10") > -1) {  
				$.messager.alert('错误提示','该功能不支持win10系统在ie下导出，请使用谷歌浏览器!',"error");
				return;	
			}  	
		}
		var ICDEdition=$('#TextEdition').combobox('getValue'); //获得ICD版本id
		var filename = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","ExportICDConData",ICDEdition);
		if(filename!=""){	
			//$.messager.progress('close');
			$(".load").attr("href","#");
			$(".load").removeAttr("download");
			$(".load").removeAttr("target");	
			filepath ="../scripts/bdp/MKB/DataExport/"+filename;
			$(".load").attr("href",filepath);
			$(".load").attr("download",filename);
			//判断浏览器是否支持a标签 download属性
			var isSupportDownload = 'download' in document.createElement('a');
			if(!isSupportDownload){
				var fileType = filename.split(".")[filename.split(".").length-1];
				if((fileType!="pdf")&&(fileType!="PDF")){
					objIframe=document.createElement("IFRAME");
					document.body.insertBefore(objIframe);
					objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
					pic   =   window.open($(".load").attr("href"),"a1");
					document.all.a1.removeNode(true)
				}else{
					alert("此浏览器使用另存下载");
					$(".load").attr("target","_blank");
				}
			}
		}else{
			$.messager.alert("提示","导出失败","error")
			//$.messager.progress('close');
		}

    }
}

$(init);
