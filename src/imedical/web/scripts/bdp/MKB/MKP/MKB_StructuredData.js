/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-11-26
* @描述:数据处理工厂
*/
var init=function()
{
    var SelMRCICDRowid=""; //诊断查找下拉框的诊断id
    var findCondition="";  //诊断描述
    var CacheDiagPropertyData={}; //快速检索中属性列表获取
    var CacheDiagPropertyDataNote={}; //快速检索中属性列表备注获取
    var PreSearchText="";
    var cbg=null;//诊断combogrid
    //var base=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Diagnose");
	var indexTemplate=undefined;//已选属性列表选中的模板id标识
	var SelPropertyArr=new Array();
	var SelPropertyData=""; //已选属性列表串

    var editIndex = undefined;
    var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var pmark = ''//标记是别名还是其他描述
	var otherfield=''//保存左侧列表字段名称 为了区分其他描述和别名
	var locbaseID=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","getTermId","LOC");//专业科室id
	var textForCopy = "" //复制文本用

	var icdflagforsel = 2//选中icd用
	var zybase=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByDesc","中医疾病诊疗知识库")		//不要受菜单配置里的base影响		//中医时取中医，西医时取临床实用诊断
    var xybase=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByDesc","临床实用诊断")
	var TCMDiagFlag="N"

	//列名变换
	var titledesc = ""  //手术名或诊断名
	var icdNumber = "" //手术编码或icd编码
	var icdDesc = "" //手术描述或icd描述
	var sourceDesc="" //数据来源描述
	if(sourceflag=="Operation"){
		sourceDesc="手术"
		titledesc = "手术名";
		icdNumber = "手术编码";
		icdDesc = "编码描述";
		document.getElementById("TextDesc").innerHTML="手术"; //改变元素内容
		document.getElementById("TipDesc").innerHTML=""; //右侧面板下的描述
		document.getElementById("TipNumber").innerHTML="手术编码:"; //右侧面板下的编码
		document.getElementById("combogridDesc").innerHTML="手术"; //右侧面板下的编码
		document.getElementById("AddDesc").innerHTML="<font color=red>*</font>手术"; //右侧面板下的编码
		$('#TipNumber').css({
			"color":"#666",
			"padding-left":"0px"
		});
		var valbox = $HUI.panel("#myPanel",{  //面板描述
			//iconCls:'icon-paper',
			headerCls:'panel-header-gray',
			title:"手术描述"
		});
	}else{
		sourceDesc="诊断"
		titledesc = "诊断名";
		icdNumber = "ICD编码";
		icdDesc = "ICD描述";
		var valbox = $HUI.panel("#myPanel",{  //面板描述
			headerCls:'panel-header-gray',
			title:"诊断"
		});
	}

	//设置加载第几项
	var indexArri = 0;
	changeIndex=function(index){
		setTimeout(function(){
			indexArri = index;
		},500);
	}

	//设置检索框的css
	$('#TextDiaSort').css({ //类型
		"width": $(window).width()*1.1/10  	//$(window).width()*1.3/10
	})
	$('#TextMate').css({ //匹配度
		"width": $(window).width()*1.1/10
	})
	$('#TextSort').css({ //排序方式
		"width": $(window).width()*1.1/10
	})
	$('#TextStatus').css({ //处理状态
		"width": $(window).width()*1.1/10
	})
	$('#TextFreMin').css({ //频次范围
		"width": $(window).width()*0.5/10
	})
	$('#TextFreMax').css({ //频次范围
		"width": $(window).width()*0.5/10
	})

	$('#TextGen').css({ //诊断
		"width": $(window).width()*1.05/10
	})

	$('#TextCenter').css({ //中心词 
		"width": $(window).width()*1.05/10
	})
	$('#TextICD').css({ //icd编码
		"width": $(window).width()*1.05/10
	})
	$('#TextLoc').css({ //专业科室
		"width": $(window).width()*1.1/10
	})
	$('#TextRLoc').css({ //实际科室
		"width": $(window).width()*1.1/10
	})
	
    /********************************************父表************************************************************************/
       var columns =[[
       {field:'Rowid',title:'诊断RowID',sortable:true,width:80,hidden:true},
       {field:'MKBSDHisRowID',title:'对应的项目诊断ID',sortable:true,width:100,hidden:true},
       {field:'MKBSDHisCode',title:'对应的项目诊断代码',sortable:true,width:100,hidden:true},

        {field:'MKBSDCenterWordID',title:'参考中心词ID',sortable:true,width:100,hidden:true},
        {field:'MKBSDCenterWord',title:'参考中心词',sortable:true,width:80,
            formatter:function(value,row,index){
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            },hidden:true
        },
        {field:'MKBSDSegmentation',title:'分词',sortable:true,width:100,
            formatter:function(value,row,index){
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            },hidden:true
		}, 
		{field:'Rowid',title:'rowid',sortable:true,width:100,hidden:true},       
        {field:'MKBSDDate',title:'操作时间',sortable:true,width:50,hidden:true},
		{field:'MKBSDUpdateUser',title:'操作人',sortable:true,width:50,hidden:true},
		{field:'Result',title:'结构化诊断',sortable:true,width:200,
			formatter:function(value,row,index){

				if(row.MKBSDResultRelation == "AND"){

					//var content = '<span class="andor"><font color="#FFFFFF">AND</font></span><span href="#" title="' + value + '" class="myresult">' + value + '</span>';
					var content = '<span class="andor"><font color="#FFFFFF" style="padding:0px 2px;">AND</font></span><span  id="Arr1" title="' + value + '" class="myresult">';
					var brArr =value.split('<br/>');
					for(var i = 0; i < brArr.length; i++){
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
						//content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/><br/>'
					}; 
					content = content + '</span>'	
				}else if(row.MKBSDResultRelation == "OR"){
					//var content = '<span class="andor"><font color="#FFFFFF">OR</font></span><span href="#" title="' + value + '" class="myresult">' + value + '</span>';
					var content = '<span class="andor"><font color="#FFFFFF" style="padding:0px 2px;">OR</font></span><span title="' + value + '" class="myresult">';
					var brArr =value.split('<br/>');
					//alert(parseInt(brArr.length/2))
					for(var i = 0; i < brArr.length; i++){
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
						//content = content + '<a href = "#" onclick="changeIndex('+i+')">'+brArr[i]+'</a><br/><br/>'
					}; 
					content = content + '</span>'	
				}else{
					//var content = '<span href="#" title="' + value + '" class="myresult">' + value + '</span>';
					var content = '<span href="#" title="' + value + '" class="myresult">';
					var brArr =value.split('<br/>');
					for(var i = 0; i < brArr.length; i++){
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
				//return (value.replace(/\*/g,"<br>"));	
			}		
		},
		{field:'MKBSDICD',title:icdNumber,sortable:true,width:100,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}		
		},
		{field:'MKBSDDeputyCode',title:'副编码',sortable:true,width:100},
		{field:'MKBSDICD9Code',title:'ICD9编码',sortable:true,width:100},
		{field:'MKBSDMrc',title:icdDesc,sortable:true,width:100,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}			
		},	
		{field:'MKBSDOAlias',title:'别名',sortable:true,width:50,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}	
		},
		{field:'MKBSDOOther',title:'其他描述',sortable:true,width:100,		
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}		
		},
		{field:'MKBSDLocStr',title:'专业科室',sortable:true,width:100,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}	
		},			
		{field:'MKBSDMDr',title:'ICDDr',sortable:true,width:150,hidden:true},
		{field:'sumloc',title:'科室总频次',sortable:true,width:80,
			formatter:function(value,row,index){
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}	
		},	
		{field:'MKBSDDiaSource',title:'数据来源',sortable:true,width:150,hidden:true},
		{field:'MKBSDLocs',title:'专业科室id',sortable:true,width:150,hidden:true},
		{field:'MKBSDAlias',title:'MKBSDAlias',sortable:true,width:150,hidden:true},
		{field:'MKBSDInitialICD',title:'最优匹配',sortable:true,width:150,hidden:true},
		{field:'MKBSDDiagPYCode',title:'拼音码',sortable:true,width:150,hidden:true},
		{field:'MKBSDStatus',title:'状态',sortable:true,width:50,
			styler:function(value,row,index){
				if(value=="Y" || value=="O"){
					return 'background-color:#2AB66A;'; //33FF66 绿 #4b991b
				}else if(value=="P"){
					return 'background-color:#FFB746;'; //FF6600 橙黄 #f58800
				}else{
					return 'background-color:#F16E57;'; //FF0033 红 #ee4f38
				}
			},
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return '<span href="#" title="已处理"  class="mytooltip"><font color="#FFFFFF">已处理</font></span>';
				}
				else if(value == "N")
				{
					return '<span href="#" title="未处理" class="mytooltip"><font color="#FFFFFF">未处理</font></span>';
				}
				else if(value == "G")
				{
					return '<span href="#" title="放弃" class="mytooltip"><font color="#FFFFFF">放弃</font></span>';
				}
				else if(value == "P")
				{
					return '<span href="#" title="预处理" class="mytooltip"><font color="#FFFFFF">预处理</font></span>';
				}				
				else if(value == "X")
				{
					return '<span href="#" title="上报待处理" class="mytooltip"><font color="#FFFFFF">上报待处理</font></span>';
				}
				else if(value == "O")
				{
					return '<span href="#" title="已审核" class="mytooltip"><font color="#FFFFFF">已审核</font></span>';
				}					
			}
		},
		{field:'MKBSDResultRelation',title:'结构化结果关系',sortable:true,width:150,hidden:true},
		{field:'MKBSDTCMDiagFlag',title:'中医诊断',sortable:true,width:80,hidden:true,
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return '是';
				}else{
					return '否';
				}
			}},
		{field:'MKBSDTCMSynFlag',title:'中医证型',sortable:true,width:80,hidden:true,
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return '是';
				}else{
					return '否';
				}
			}},
		{field:'MKBSDTumourFlag',title:'肿瘤形态学编码',sortable:true,width:80,hidden:true,
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return '是';
				}else{
					return '否';
				}
			}},
		{field:'MKBSDInjuryFlag',title:'损伤中毒外部原因',sortable:true,width:80,hidden:true,
			formatter:function(value,row,index){
				if(value=="Y")
				{
					return '是';
				}else{
					return '否';
				}
			}},
		{field:'MKBSDDateActiveFrom',title:'开始日期',sortable:true,width:80,hidden:true},
		{field:'MKBSDDateActiveTo',title:'结束日期',sortable:true,width:80,hidden:true},
		
		{field:'MKBSDClinicType',title:'icd诊断分类',sortable:true,width:80,hidden:true},
		{field:'MKBSDClassification',title:'就诊类型',sortable:true,width:100,hidden:true},
		{field:'MKBSDLimitSex',title:'限制性别',sortable:true,width:80,hidden:true},
		{field:'MKBSDHisRemark',title:'注释',sortable:true,width:80,hidden:true},
		{field:'MKBSDAgeFrom',title:'从年龄',sortable:true,width:80,hidden:true},
		{field:'MKBSDAgeTo',title:'到年龄',sortable:true,width:80,hidden:true},
		{field:'MKBSDNationalDesc',title:'国家标准名称',sortable:true,width:80,hidden:true},
		{field:'MKBSDMatchGlobalFlag',title:'能否匹配全局化词表',sortable:true,width:80,hidden:true}


    ]];
    var leftgrid = $HUI.datagrid("#leftgrid",{

        columns: columns,  //列信息
        pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:100,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
		checkOnSelect:false,
		frozenColumns:[[
			{field:'ck',checkbox:true},
			{field:'MKBSDDiag',title:titledesc,sortable:true,width:220,
				formatter:function(value,row,index){
					//console.log(row.MKBSDInitialICD)
					if(row.MKBSDInitialICD == "Y"){
						var content = '<span class="besticd"><font color="#FFFFFF" style="padding:0px 2px;">优</font></span><span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
					}else{
						var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
					}			
					return content;
				}
			}			   			
		]],
        selectOnCheck:false,
        remoteSort:false,
        ClassTableName:'User.MKBStructuredData'+STBBase,
        SQLTableName:'MKB_StructuredData',
        idField:'Rowid',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            //$(this).datagrid('columnMoving');
			$("#leftgrid").datagrid('unselectAll');
			$('#leftgrid').datagrid('clearSelections');
			$('#leftgrid').datagrid('clearChecked');
			$("#leftgrid").datagrid('uncheckAll');
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
		},
		onClickCell:function(index, field, value){
			//copyToCommand(value)
			//textForCopy = value
		},
		onDblClickCell:function(rowIndex,field,value){
			var record=$('#leftgrid').datagrid('getSelected')
			if(record.MKBSDStatus=="O" && field!="Result"){
				$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
				return;
			}
			var col=$('#layoutwest').children().find('tr[datagrid-row-index='+rowIndex+']');
			if(field == "MKBSDICD" || field == "MKBSDMrc"){//ICD
				icdflagforsel = 1
				if(field == "MKBSDICD"){
					var target=$(col).find('td[field=MKBSDICD]')
					$('#TextInterDesc').val('');
					$('#TextInterCode').val('');
					$('#TexticdDesc').val('')
					$('#TexticdCode').val(record.MKBSDICD.slice(0,6))
					$('#ICDGrid').datagrid('load',  { 
						ClassName:"web.DHCBL.MKB.MKBStructuredData",
						QueryName:"GetICDTermList",
						number:record.MKBSDICD,
						base:icdtermbase
					});
						
				}else{
					var target=$(col).find('td[field=MKBSDMrc]')
					$('#TextInterDesc').val('');
					$('#TextInterCode').val('');
					$('#TexticdDesc').val(record.MKBSDMrc)
					$('#TexticdCode').val('')
					$('#ICDGrid').datagrid('load',  { 
						ClassName:"web.DHCBL.MKB.MKBStructuredData",
						QueryName:"GetICDTermList",
						desc:record.MKBSDMrc,
						base:icdtermbase
					});

				}
				var text = (record.MKBSDICD).slice(0,3);//只要数点前边的数字
				$('#TextInterDesc').val('');
				$('#TextInterCode').val(text);
				$('#interGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
					MethodName:"GetMyList",
					base : icdBase,
					desc : text
				});	

				//$('#ICDGrid').datagrid('unselectAll')
				var t = $("#icdDiv")
				$("#otherDiv").hide();
				showICDDiv(target,t);			
				//CreatPropertyDom(target,SelMRCICDRowid,SDSRowId,indexTemplate);
			}else if(field == "MKBSDOAlias"){//其他描述
				var target=$(col).find('td[field=MKBSDOAlias]')
				var t = $("#otherDiv")
				$("#icdDiv").hide();
				pmark = "AN"
				$('#othergrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBStructuredData",
					QueryName:"GetOtherList",
					id:record.Rowid,
					mark:pmark	
				});
				otherfield = 'MKBSDOAlias'
				$('#othergrid').datagrid('unselectAll');
				othereditIndex = undefined;
				otherrowsvalue=undefined;				
				showOtherDiv(target,t);
						
			}else if(field == "MKBSDOOther"){//别名
				var target=$(col).find('td[field=MKBSDOOther]')
				var t = $("#otherDiv")
				$("#icdDiv").hide();
				pmark = "OD"
				otherfield = 'MKBSDOOther'
				$('#othergrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBStructuredData",
					QueryName:"GetOtherList",
					id:record.Rowid,
					mark:pmark	
				});
				$('#othergrid').datagrid('unselectAll');
				othereditIndex = undefined;
				otherrowsvalue = undefined;				
				showOtherDiv(target,t);
						
			}else if(field == "Result"){//跳转到二厂
				JumpToSecond()
			}
		},
        onClickRow:function(rowIndex,row)
        { 
        	if ((row.MKBSDTCMDiagFlag=="Y")||(row.MKBSDTCMDiagFlag=="是"))
        	{
        		TCMDiagFlag="Y"
        	}
        	else
        	{
        		TCMDiagFlag="N"
        	}
			$("#icdDiv").hide();
			$("#otherDiv").hide();
			  //可编辑表格部分
            $('#leftgrid').datagrid('selectRow', rowIndex);
            ClickFun();

			//单机才赋值url
			options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
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
			 
			locoptions={};
			locoptions.url=$URL;
			locoptions.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				QueryName:"GetLocList",
				id:row.Rowid
			}	
			$('#centerLocGrid').datagrid(locoptions);					
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
            var mygridmm = $('<div style="width:170px;"></div>').appendTo('body');
            var divstr='<div onclick="copyToCommand()" iconCls="icon-copyorder" data-options="">复制文本</div>'
            if  (row.sumloc!=0)
            {
            	 divstr=divstr+'<div onclick="overRealityLoc()" iconCls="icon-copyorder" data-options="">查看实际科室</div>'  	 
            }
            divstr=divstr+'<div onclick="copyResultBtn()" iconCls="icon-copyorder" data-options="">复制结构化'+sourceDesc+'</div>' +
				//'<div onclick="JumpToSecond()" iconCls="icon-copyorder" data-options="">查找相似结构化诊断</div>' +
				'<div onclick="copyICDBtn()" iconCls="icon-copyorder" data-options="">复制ICD</div>' +
				'<div onclick="copyProLoc()" iconCls="icon-copyorder" data-options="">复制科室</div>' +
				'<div onclick="pasteResultBtn()" iconCls="icon-paste" data-options="">粘贴</div>'+
				'<div onclick="dealTNM()" iconCls="icon-paste" data-options="">批量处理TNM</div>'+
				'<div onclick="combineBtn()" iconCls="icon-paper-link" data-options="">合并</div>'+
				'<div onclick="DeleteDiaData()" iconCls="icon-cancel" data-options="">删除</div>'+
				'<div class="menu-sep"></div>'+
				'<div iconCls="icon-changeposition">'+
				'<span>最优匹配</span>'+
					'<div style="width:80px;">'+
						'<div onclick="conInitIcd(1)" iconCls="icon-ok" id="shiftup">设置最优</div>'+
						'<div onclick="conInitIcd(2)" iconCls="icon-cancel" id="shiftdown">取消最优</div>'+
					'</div>'+
				'</div>'	
            $(divstr).appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });

            //刷新表格
            $('#leftgrid').datagrid('selectRow', rowIndex);
			ClickFun();

			options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				QueryName:"GetResultList",
				id:row.Rowid
			}	
			$('#mygrid').datagrid(options);		    
			$("#mygrid").datagrid('unselectAll');						
            /*$('#mygrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBStructuredData",
                QueryName:"GetResultList",
                id:row.Rowid
			}); */
			
			locoptions={};
			locoptions.url=$URL;
			locoptions.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				QueryName:"GetLocList",
				id:row.Rowid
			}	
			$('#centerLocGrid').datagrid(locoptions);
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
	
	ShowUserHabit('leftgrid');//用户习惯

	//一厂跳转到二厂
	JumpToSecond = function(){
		var record = $('#leftgrid').datagrid('getSelected')
		var Data = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetSingleData",record.Rowid)
		Data = eval('('+Data+')'); 
		var jumpidsS = Data.MKBSDResultID
		var jumptermdrS = Data.MKBSDResultTermdr
		var jumpSupplementS = Data.MKBSDSupplement
		var jumpflagS = 1
		if (jumptermdrS=="")
		{
			jumpflagS=""
		}
		var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.stb2."+STBBase);
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

		window.parent.showNavTab(menuid,Caption,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&jumpidsS="+jumpidsS+"&jumptermdrS="+jumptermdrS+"&jumpSupplementS="+jumpSupplementS+"&jumpflagS="+jumpflagS+"&jumpflag2="+1,parentid,menuimg)

	}
	//页面跳转与普通加载
	if(jumpflag != ""){//二厂跳过来

		if(jumpflag == 1){//结构化完全相同结果
			options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredSecondData",
				QueryName:"GetSameStructResult",
				ids:jumpids,
				//user:"default",//默认显示全部
				termdr:jumptermdr,
				supplement:jumpSupplement,
				basedr:STBBase
			}
		}else{//结构化包含查询内容
			options={};
			options.url=$URL;
			options.queryParams={
				ClassName:"web.DHCBL.MKB.MKBStructuredSecondData",
				QueryName:"GetNotSameIdsButSameItem",
				ids:jumpids,
				//user:"default",//默认显示全部
				termdr:jumptermdr,
				supplement:jumpSupplement,
				basedr:STBBase
			}			
		}
		$('#leftgrid').datagrid(options);
		$("#leftgrid").datagrid('unselectAll');
	}else{//点击菜单打开对应页面
		options={};
		options.url=$URL;
		options.queryParams={
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			MethodName:"GetNewList",
			status:"",//默认显示全部
			//user:"default",//默认显示全部
			sort:3,//默认按科室总频次排序
			mark:"",
			match:"A",
			basedr:STBBase
		}
		$('#leftgrid').datagrid(options);
		$("#leftgrid").datagrid('unselectAll');			
	}

	//批量处理TNM
	dealTNM = function(){
		var id = $('#leftgrid').datagrid('getSelected').Rowid
		var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","DealTNM",id);
		var data=eval('('+result+')');
		if(data.success=='true'){  
			$.messager.popover({msg: '批处理成功!',type:'success',timeout: 1000});
			$('#leftgrid').datagrid('reload');
		}else{
			var errorMsg="处理失败！";
			if(data.errorinfo){
				errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
			}
			$.messager.alert('错误提示',errorMsg,'error')
		}		
	}
	//单机参考中心词、诊断名、icd描述将内容复制到剪贴板
	copyToCommand = function(a){//a 内容标志
		//2 中心词  3icd描述  1 诊断名
		var record = $('#leftgrid').datagrid('getSelected')
		var text = ""
		if(a == "3"){
			text = record.MKBSDMrc
		}else if(a == "2"){
			text = record.MKBSDCenterWord
		}else if(a == "1"){
			text = record.MKBSDDiag
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
		if(row.MKBSDInitialICD == "Y"){
			$HUI.checkbox("#Initial_ICD").setValue(true)
		}else{
			$HUI.checkbox("#Initial_ICD").setValue(false)
		}*/
		/*$('.Initial_ICD').remove();
		if(row.MKBSDInitialICD == "Y"){
			var initIcd = '<font color = green class="Initial_ICD">是</font>'
		}else{
			var initIcd = '<font color = green class="Initial_ICD">否</font>'
		}
		$('#init_icd').append(initIcd);*/

		//icd10
		$('.viewicd10').remove();
		var icdp2='<font class="viewicd10">'+row.MKBSDICD+'</font>'
		$('#icd_code').append(icdp2);

		$('.viewicd').remove();
		if(row.MKBSDMrc!=""&&(row.MKBSDMrc).length>6){
			var icdp1='<a color=red class="viewicd" href="javascript:void(0) onClick="copyToCommand(3)"><font color=#000>'+(row.MKBSDMrc).substring(0,5)+'...</font></a>'
		}else{
			var icdp1='<a color=red class="viewicd" href="javascript:void(0) onClick="copyToCommand(3)"><font color=#000>'+row.MKBSDMrc+'</font></a>'
		}
		if (sourceflag!="Operation"){ //只有为诊断时才给描述赋值
			$('#icd_desc').append(icdp1);
		}

		//诊断短语
		/*$('.view2').remove();
		if(row.MKBSDDiag != "" && (row.MKBSDDiag).length>6){
			var p2 = '<a color=red class="view2" href="javascript:void(0) onClick="copyToCommand(1)"><font color=#000>'+(row.MKBSDDiag).substring(0,5)+'...</font></a>'
		}else{
			var p2 = '<a href="javascript:void(0) color=red class="view2" onClick="copyToCommand(1)"><font color=#000>'+row.MKBSDDiag+'<font></a>'
		}
		$('#termViewId').append(p2);*/
		//右侧面板
		var valbox = $HUI.panel("#myPanel",{
			//iconCls:'icon-paper',
			headerCls:'panel-header-gray',
			//fit:'true',
			title:row.MKBSDDiag
			//width:800,
			//padding:5
		});
		//面板title的点击事件
		$('body').on('click','.panel-title',function () { copyToCommand(1); }); 
		//$('.icon-paper').click(function () { copyToCommand(1); });
		
		//参考中心词显示
		$('.view3').remove();
		if(row.MKBSDCenterWord != "" && (row.MKBSDCenterWord).length>6){
			var p3 = '<a class="view3" href="javascript:void(0) onClick="copyToCommand(2)"><font color=#000>'+(row.MKBSDCenterWord).substring(0,5)+'...</font></a>'
		}else{
			var p3 = '<a class="view3" href="javascript:void(0) onClick="copyToCommand(2)"><font color=#000>'+row.MKBSDCenterWord+'<font></a>'
		}
		$('#termWordId').append(p3);  
					
		//分词显示(传入格式 分词（属性；属性）)
		$('#contentId').html("")
		var indexFlag = (row.MKBSDSegmentation).indexOf("(")
		if(indexFlag >= 0)
		{
			//中心词
			var segContent = (row.MKBSDSegmentation).split('(')[0];
			var flagCon = segContent.indexOf("，");
			if(flagCon >= 0)
			{
				var conArr = segContent.split("，");
				for(var i = 0; i<conArr.length; i++)
				{
					if(i != (conArr.length-1))
					{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a>') //redgreen
					}
					else
					{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp(</font>') //redgreen
					}
				}
			}
			else
			{
				$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+segContent+'</font></a><font color=#017bec class="trView">&nbsp&nbsp(</font>')	//redgreen				
			}

			//属性
			var segPro = ((row.MKBSDSegmentation).split('(')[1]).substring(0,10);
			//去掉右括号
			var segPro1= segPro
			segPro = segPro.replace(")","");
			var proArr = segPro.split("，")
			for(var i = 0; i<proArr.length; i++)
			{
				if(i != (proArr.length-1))
				{
					$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a>')
				}
				else
				{
					if(segPro1.indexOf(')')>-1){
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp)</font>')

					}else{
						$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+proArr[i]+'</font></a><font color=#017bec class="trView">&nbsp&nbsp...</font>')
					}
				}
			}
		}
		else
		{
			var conArr = (row.MKBSDSegmentation).split("，");
			for(var i = 0; i<conArr.length; i++)
			{
				$('#contentId').append('&nbsp&nbsp<a class="trView" href="javascript:void(0) onClick="putTextIntoCom(this)"><font color=#017bec >'+conArr[i]+'</font></a>')
			}				
		}		
	}
	//点击分词添加到下结构化查询框
	putTextIntoCom = function(obj)
	{
		var thisDesc = $(obj).text()
		$('#Form_DiagPropertySearchText').searchbox('setValue',thisDesc);
	}

    $('#result_xhfBtn').click(function(e){ //refreshRow
        updataStatic("X")    
    })
    //确认和放弃按钮
    $('#result_ConfirmBtn').click(function(e){ //refreshRow
        updataStatic("Y")    
    })
    $('#result_GiveUpBtn').click(function(e){
        updataStatic("G")
	}) 
	//预处理
    $('#result_PrepareBtn').click(function(e){
        updataStatic("P")
	})	
	//未处理
    $('#result_UnProBtn').click(function(e){
        updataStatic("N")
	})	
	//未处理
    $('#result_OverBtn').click(function(e){
        updataStatic("O")
	})	
	//修改处理状态		
    updataStatic = function(flag){
		setTimeout(function(){
			var records =  $('#leftgrid').datagrid('getChecked')
			if(records != ""){
				//alert(records.length)
				var lengthR = records.length;
				var overflag="" //判断是否已经选中已审核的数据
				var icdflag=""//判断是否维护了icd
				var resultflag=""//判断是否维护了结构化诊断
				for(var i = 0; i < records.length; i++){
					var record = records[i]
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
					
					if(resultIndex > -1 && records[i].MKBSDStatus=="O"){
						overflag = "Y"
					}
					if(resultIndex > -1 && records[i].MKBSDMrc == "" && flag == "O"){
						icdflag = "Y"
					}
					if(resultIndex > -1 && records[i].Result == "" && flag == "O"){
						resultflag = "Y"
					}
				}
				if(icdflag=="Y"){
					$.messager.alert('提示','请先维护关联的ICD，再进行审核!',"error");
					return;	
				}
				if(resultflag=="Y"){
					$.messager.alert('提示','请先维护结构化'+sourceDesc+'，再进行审核',"error");
					return;	
				}
				if(overflag=="Y"){
					$.messager.alert('提示','已审核的数据不能更改处理状态，请去掉勾选!',"error");
					return;	
				}
				//保存
				for(var i = 0; i < records.length; i++){
					var record = records[i]
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
					if(resultIndex > -1 && records[i].MKBSDStatus!="O"){
						var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",record.Rowid,flag,"","","","","");//1
						var data=eval('('+result+')');
						if(data.success=='true'){   
							$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDStatus = flag;
							$('#leftgrid').datagrid('refreshRow',resultIndex)
							$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});	
					    } 
					}
				}
			}else{
				$.messager.alert('错误提示','请先勾选一条记录!',"error");
				return;
			}

		},50)          
    }   
      //左侧列表点击方法
    loadRightResult = function(row){
        //如果已经有诊断结果，则默认加载第一条
		//alert(row.MKBSDCenterWord)
		PreSearchText = "";//清空检索框   石萧伟20190827
        var ccc = $('#combogrid') 
        /*if($('#mygrid').datagrid('getData').total > 0){
            $('#mygrid').datagrid('selectRow',0);
            var resultSel = $('#mygrid').datagrid('getSelected')
			var termid=resultSel.MKBSDTermDR
			var termDesc = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","getDescById",termid); 
            //alert(termDesc+"*"+termid)
            CreatPropertyDom("",termid,resultSel.Rowid,"");   
            LoadDiagnosData(termDesc,ccc);//加载诊断下拉框
            $('#combogrid').combogrid('setValue',termid);                    
            setTimeout(function(){
            //诊断列表有选中时，才允许弹出属性列表
                findCondition = "" ; 
            },50)    
            
            //$("#Form_DiagDesc").val(resultSel.MKBSDStructResult)

			SelMRCICDRowid = termid
			
			$("#div-img").hide();
        } */
        //只按照匹配到的中心词展示
		if(row.MKBSDCenterWord != "" && row.Result == ""){//&& ($('#mygrid').datagrid('getData').total == 0)){//否则按照匹配的参考中心新词来加载
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","JustTermClose",row.MKBICDCenterWordID)//封闭标识
			if(flag != "N"){
				var termDesc = (row.MKBSDCenterWord).split("、")[0];
				var termid = (row.MKBSDCenterWordID).split(",")[0];
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
		}else if(row.MKBSDCenterWord == ""){//&& ($('#mygrid').datagrid('getData').total == 0)){//都没有就不加载
			SelPropertyData=""
			LoadDiagnosData("",ccc);
			$('#combogrid').combogrid('setValue',''); 
			$("#div-img").show();
        }     
	 }

	 //查看实际科室按钮
	 overRealityLoc	 = function(){
		var record=$('#leftgrid').datagrid('getSelected');
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		$('#realityloc').show();	
        var realityloc = $HUI.dialog("#realityloc",{
            iconCls:'icon-house-posi-maint',
            resizable:true,
			title:'实际科室',
			width:$(window).width()*5/10,
			height:$(window).height()*7/10,
            modal:true
		});	
	 }

	 //删除左侧列表数据
	 DeleteDiaData=function(){
		var record=$('#leftgrid').datagrid('getSelected');
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}

		
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.Rowid;
				$.ajax({
					url:"./dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=DeleteDataF",
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#leftgrid').datagrid('reload');
							$('#leftgrid').datagrid('unselectAll');
							//editIndex = undefined;
							//rowsvalue=undefined;
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

	//修改父表诊断名
	$('#editdia_btn').click(function(e){
		UpdateData();
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
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				$('#adddia_form').form("load",jsonData);
				if (jsonData.MKBSDTCMDiagFlag=="Y")
				{
					$HUI.checkbox("#MKBSDTCMDiagFlag").setValue(true);	
				}else{
					$HUI.checkbox("#MKBSDTCMDiagFlag").setValue(false);
				}
				if (jsonData.MKBSDTCMSynFlag=="Y")
				{
					$HUI.checkbox("#MKBSDTCMSynFlag").setValue(true);	
				}else{
					$HUI.checkbox("#MKBSDTCMSynFlag").setValue(false);
				}
				if (jsonData.MKBSDTumourFlag=="Y")
				{
					$HUI.checkbox("#MKBSDTumourFlag").setValue(true);	
				}else{
					$HUI.checkbox("#MKBSDTumourFlag").setValue(false);
				}
				if (jsonData.MKBSDInjuryFlag=="Y")
				{
					$HUI.checkbox("#MKBSDInjuryFlag").setValue(true);	
				}else{
					$HUI.checkbox("#MKBSDInjuryFlag").setValue(false);
				}
				if (jsonData.MKBSDClinicType=="")
				{
					$HUI.checkbox("#TypeO").setValue(true);
					$HUI.checkbox("#TypeE").setValue(true);
					$HUI.checkbox("#TypeI").setValue(true);
					$HUI.checkbox("#TypeH").setValue(true);
					$HUI.checkbox("#TypeN").setValue(true);
				}
				else
				{
					//E,I,N
					if (jsonData.MKBSDClinicType.indexOf("O")!=-1)
					{
						$HUI.checkbox("#TypeO").setValue(true);
					}
					else
					{
						$HUI.checkbox("#TypeO").setValue(false);
					}
					if (jsonData.MKBSDClinicType.indexOf("E")!=-1)
					{
						$HUI.checkbox("#TypeE").setValue(true);
					}
					else
					{
						$HUI.checkbox("#TypeE").setValue(false);
					}
					if (jsonData.MKBSDClinicType.indexOf("I")!=-1)
					{
						$HUI.checkbox("#TypeI").setValue(true);
					}
					else
					{
						$HUI.checkbox("#TypeI").setValue(false);
					}
					if (jsonData.MKBSDClinicType.indexOf("H")!=-1)
					{
						$HUI.checkbox("#TypeH").setValue(true);
					}
					else
					{
						$HUI.checkbox("#TypeH").setValue(false);
					}
					if (jsonData.MKBSDClinicType.indexOf("N")!=-1)
					{
						$HUI.checkbox("#TypeN").setValue(true);
					}
					else
					{
						$HUI.checkbox("#TypeN").setValue(false);
					}
				}
					
				
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
	}/*
	UpdateDia = function(record){
		var MKBSDDiag = $('#MKBSDDiag').val();
		var MKBSDDiagPYCode = $('#MKBSDDiagPYCode').val();
		var MKBSDNote = $('#MKBSDNote').val();
		var ICD = $('#MKBSDICD').val();
		var DateActiveFrom = $('#MKBSDDateActiveFrom').datebox('getValue');
		var DateActiveTo = $('#MKBSDDateActiveTo').datebox('getValue');
		var TCMDiagFlag = $HUI.checkbox("#MKBSDTCMDiagFlag").getValue();
		if (TCMDiagFlag=="1") TCMDiagFlag="Y"
		else TCMDiagFlag="N"
		var TCMSynFlag = $HUI.checkbox("#MKBSDTCMSynFlag").getValue();
		if (TCMSynFlag=="1") TCMSynFlag="Y"
		else TCMSynFlag="N"
		var TumourFlag = $HUI.checkbox("#MKBSDTumourFlag").getValue();
		if (TumourFlag=="1") TumourFlag="Y"
		else TumourFlag="N"
		var InjuryFlag = $HUI.checkbox("#MKBSDInjuryFlag").getValue();
		if (InjuryFlag=="1") InjuryFlag="Y"
		else InjuryFlag="N"
		if (MKBSDDiag=="")
        {
            $.messager.alert('错误提示',sourceDesc+'不能为空!',"error");
            return;
		}
		if (ICD==""){
			$.messager.alert('错误提示','ICD编码不能为空!',"error");
            return;
		}
		if (MKBSDDiagPYCode=="")
        {
            $.messager.alert('错误提示','拼音码不能为空!',"error");
            return;
		}		
		var rowid = record.Rowid;
		var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","UpdateParDia",rowid,MKBSDDiag,MKBSDDiagPYCode,MKBSDNote,ICD,DateActiveFrom,DateActiveTo,TCMDiagFlag,TCMSynFlag,TumourFlag,InjuryFlag);
		var data=eval('('+result+')');
		if(data.success=='true'){
			$.messager.popover({msg: '修改成功!',type:'success',timeout: 1000});
			$("#adddia_win").dialog('close');
			//修改成功后刷新行数据
			var resultIndex = $('#leftgrid').datagrid('getRowIndex',record) 
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDDiag = MKBSDDiag;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDICD = ICD;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMrc = MKBSDDiag;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDNote = MKBSDNote;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDDateActiveFrom = DateActiveFrom;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDDateActiveTo = DateActiveTo;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDTCMDiagFlag = TCMDiagFlag;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDTCMSynFlag = TCMSynFlag;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDTumourFlag = TumourFlag;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDInjuryFlag = InjuryFlag;
			$('#leftgrid').datagrid('refreshRow',resultIndex)			
		}else{
			var errorMsg ="新增失败！"
			if (data.errorinfo) {
				if((data.errorinfo).indexOf("键不唯一")){
					errorMsg =errorMsg+ '<br/>错误信息:已存在同名的数据！'
				}else{
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
			}
			$.messager.alert('操作提示',errorMsg,"error");			
		}
	}*/
	//新增父表数据
	$('#adddia_btn').click(function(e){
		AddDiaData();
	})
	formatterDate = function(date) {
        var curr_time=new Date();   
        var strDate=curr_time.getFullYear()+"-";   
        strDate +=curr_time.getMonth()+1+"-";   
        strDate +=curr_time.getDate()
        return strDate
    };
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
        $('#MKBSDDateActiveFrom').datebox("setValue",formatterDate())
	}
	//诊断名检索框输入时，实时更新拼音码
	$('#MKBSDDiag').keyup(function(){	
		var desc=$('#MKBSDDiag').val() //中心词列的值		
		//检索码赋值
		var PYCode=Pinyin.GetJPU(desc);
		$('#MKBSDDiagPYCode').val(PYCode);					
	});

	$('#MKBSDAgeFrom').numberbox({
	    min:0
	});
	$('#MKBSDAgeTo').numberbox({
	    min:0
	});
	//限制性别
	$('#MKBSDLimitSex').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTSex&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTSEXRowId',
		textField:'CTSEXDesc'
	});
	//诊断分类
	$('#MKBSDClassification').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.MRCICDDxType&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ICDTYPERowId',
		textField:'ICDTYPEDesc'
	});


	//诊断名保存
	SaveDiaData = function(id){
		var DIA_SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBStructuredData";
		/*if ($.trim($("#MKBSDHisCode").val())=="")
		{
			$.messager.alert('错误提示','诊断代码不能为空!',"info");
			return;
		}*/
		if ($.trim($("#MKBSDDiag").val())=="")
		{
			$.messager.alert('错误提示','诊断描述不能为空!',"info");
			return;
		}
		if ($.trim($("#MKBSDICD").val())=="")
		{
			$.messager.alert('错误提示','ICD编码不能为空!',"info");
			return;
		}
		if ($.trim($("#MKBSDDiagPYCode").val())=="")
		{
			$.messager.alert('错误提示','拼音码不能为空!',"info");
			return;
		}
		var TypestrArr = new Array();
        $("input[name='Type']:checked").each(function(i){
            TypestrArr[i] = $(this).val();
        });
        var TypeVals = TypestrArr.join(",");

        //console.log(TypeVals)
        
		var Typestr=""
		//（门诊O。急诊E。住院I。体检H。新生儿N）
		
		$("#MKBSDClinicType").val(TypeVals)
		//var rowid=$("#MKBSDRowid").val()
		var desc=$.trim($("#MKBSDDiag").val())
		var code=$.trim($("#MKBSDICD").val())
		var hisid=$.trim($("#MKBSDHisRowID").val())
		var flag = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredBase","FormValidateDiagICD",id,desc,code,hisid,STBBase);	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		
		$('#adddia_form').form('submit', { 
			url: DIA_SAVE_ACTION_URL,
			onSubmit: function(param) {
	            param.MKBSDBaseDr = STBBase;
	        }, 
			success: function (data) { 
				    var data=eval('('+data+')'); 
				    if (data.success == 'true') {
				  		$.messager.popover({msg: '提交成功!',type:'success',timeout: 1000});
						$('#MKBSDDiag').val('');
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
	//设置初始icd
	conInitIcd = function(flag){
		if(flag == 1){
			var flagt = "Y"
		}else{
			var flagt = "N"
		}
		var record = $('#leftgrid').datagrid('getSelected');
		if(record){
				if(record.MKBSDMrc == "" && flagt == "Y"){
					$.messager.alert('提示','请先关联一条ICD后再进行设置!',"error");
					return;		
				}
				if(record.Result == "" && flagt == "Y"){
					$.messager.alert('提示','请先维护一条结构化'+sourceDesc+'再进行设置!',"error");
					return;		
				}
				var MKBSDInitialICD = flagt;
				var icdFlag = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","findInitialICD",record.Rowid);
				var icdflagdesc = icdFlag.split("*")[0]
				var icdflagid = icdFlag.split("*")[1]
				if(flagt=="Y"&&icdFlag!=""){
					$.messager.confirm('提示', '已有'+sourceDesc+'短语<font color=red>'+icdflagdesc+'</font>设置为最优匹配,是否重新设置？', function(r){
						if (r){
							var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","InitialICDUpdate",record.Rowid,MKBSDInitialICD);
							var result2=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","InitialICDUpdate",icdflagid,"N");
							var data=eval('('+result+')');
							if(data.success=='true'){
								$.messager.popover({msg: '设置成功！',type:'success',timeout: 1000}); 
								searchFunLibData("");
							}
						}
					})
				}else{
					var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","InitialICDUpdate",record.Rowid,MKBSDInitialICD);
					var data=eval('('+result+')');
					if(data.success=='true'){		
						var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDInitialICD = MKBSDInitialICD;
						$('#leftgrid').datagrid('refreshRow',resultIndex)	
						$.messager.popover({msg: '设置成功！',type:'success',timeout: 1000}); 
					}					
				}
				

		}else{
			//$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
			//return;			
		}
	}
	//最优icd勾选
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
							var MKBSDInitialICD = flagt;
							var icdFlag = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","findInitialICD",record.Rowid);
							if(flagt=="Y"&&icdFlag!=""){
								$.messager.alert('提示','已有诊断短语<font color=red>'+icdFlag+'</font>设置为最优匹配，请检查！',"error");
								$HUI.checkbox("#Initial_ICD").setValue(false)
								return;	
							}
							var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","InitialICDUpdate",record.Rowid,MKBSDInitialICD);
							var data=eval('('+result+')');
							if(data.success=='true'){
								var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
								$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDInitialICD = MKBSDInitialICD;
								$('#leftgrid').datagrid('refreshRow',resultIndex)	
							}
		
					}else{
						//$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
						//return;			
					}
				},50)
	
		}
	})*/

	 /*****************************************************父表结束****************************************/  
	/*********************************************科室频次展示********************************************/
	var centerGrid=$HUI.datagrid("#centerLocGrid",{
		//url:$URL,		
		columns: [[  
			{field:'Rowid',title:'rowid',width:50,sortable:true,hidden:true},
			{field:'MKBSDLoc',title:'科室',width:100,sortable:true,
			formatter:function(value,rec){ 
					 //鼠标悬浮显示备注
					value="<span class='hisui-tooltip' title='"+value+"'>"+value+"</span>" 
					return value;
					
				} 
			},
			{field:'MKBSDFrequency',title:'频次',width:50,sortable:true},
			{field:'MKBSDLocSource',title:'类型',width:50,sortable:true,
				formatter:function(value,rec){
					if(value=="I"){
						return "住院"
					}else if(value == "L"){
						return "出院"
					}else if(value == "O"){
						return "门急诊"
					}
				},hidden:true
		
			}
		]],
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:100,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		idField:'Rowid',
		singleSelect:true,
		showHeader:false,
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		resizable:true,
		fixed:true,
		scrollbarSize :0,
		remoteSort:false  //定义是否从服务器排序数据。true
	});	
	 /********************************************科室频次展示结束****************************************/
    /**********************************************复制粘贴功能开始****************************************/
     //存数据的全局变量
     var dataContainer = "";
     var copyFlag = ""
     //父表点击复制按钮
     //$('#copyResultBtn').click(function(e){
     //父表复制结构化
    copyResultBtn=function(){
        dataContainer = $('#mygrid').datagrid('getData')
		copyFlag = 1;
        //$('#leftBarForCopy').menu('close')
    }
    //子表点击复制结构化
    copyResultCBtn = function(){
		dataContainer = $('#mygrid').datagrid('getSelected')
        copyFlag = 2

	 }
	 //父表icd复制
	 copyICDBtn = function(){
		dataContainer = $('#leftgrid').datagrid('getSelected')
		copyFlag = 3
	 }
	 //父表复制科室
	 copyProLoc = function(){
		dataContainer = $('#leftgrid').datagrid('getSelected')
		copyFlag = 4		 
	 }
    //批量处理按钮
    $('#result_PasteAll').click(function(e){
		if(dataContainer == "")
		{
			$.messager.alert('错误提示','请先右键复制一条记录!',"error");
            return;
		}	
        var records =  $('#leftgrid').datagrid('getChecked')
        if(records != ""){
			var overflag=""
			for(var i = 0; i < records.length; i++){
				var record = records[i]
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				if(resultIndex > -1 && records[i].MKBSDStatus=="O"){
					overflag="Y"
				}
			}
			if(overflag=="Y"){
				$.messager.alert('错误提示','已审核的数据不能更改处理状态，请去掉勾选!',"error");
				return;	
			}				
		
            if(copyFlag == 1){
				if(dataContainer.rows.length==0){
					$.messager.alert('错误提示','复制数据的结构化'+sourceDesc+'为空!',"error");
					return;				
				}					
                for(var i = 0;i < dataContainer.rows.length; i++){
                    for(var j = 0; j < records.length; j++){
                        var parId = records[j].Rowid
                        var MKBSDStructResultID = dataContainer.rows[i].MKBSDStructResultID
                        //alert(MKBSDStructResultID)
                        var MKBSDStructResult = dataContainer.rows[i].MKBSDStructResult
                        var MKBSDTermDR = dataContainer.rows[i].MKBSDTermDR
                        var MKBSDSupplement = dataContainer.rows[i].MKBSDSupplement
                        var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justHasExist",parId,MKBSDTermDR);
                        if(existStr != ""){
							tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,existStr.split("^")[0],MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
                        }else{
                            tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);                       
                        }
						var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[j])
						$('#leftgrid').datagrid('getRows')[resultIndex].Result = dataContainer.rows[0].MKBSDStructResult;
						$('#leftgrid').datagrid('refreshRow',resultIndex)
                    }              
				} 
				$.messager.popover({msg: '批处理成功！',type:'success',timeout: 1000});          
            }
            else if(copyFlag==2){				
                for(var k = 0; k < records.length; k++){
                    var parId = records[k].Rowid                
                    //var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
                    var MKBSDStructResultID = dataContainer.MKBSDStructResultID
                    //alert(MKBSDStructResultID)
                    var MKBSDStructResult = dataContainer.MKBSDStructResult
                    var MKBSDTermDR = dataContainer.MKBSDTermDR
                    var MKBSDSupplement = dataContainer.MKBSDSupplement
                    var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justHasExist",parId,MKBSDTermDR);
                    if(existStr != ""){
                        tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,existStr.split("^")[0],MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
                    }else{                    
                        tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
					}
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[k])
					$('#leftgrid').datagrid('getRows')[resultIndex].Result = dataContainer.MKBSDStructResult;
					$('#leftgrid').datagrid('refreshRow',resultIndex)					
				}  
				$.messager.popover({msg: '批处理成功！',type:'success',timeout: 1000});                
            }else{
				$.messager.alert('错误提示','只支持结构化'+sourceDesc+'的批处理!',"error");
				return;
			}
            
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
    })
    //粘贴方法
	pasteResultBtn = function(){//1是复制多条，2是复制右侧单条
		var overrecord = $('#leftgrid').datagrid('getSelected');
		if(overrecord.MKBSDStatus=="O"){
			$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
			return;
		}
		if(dataContainer == "")
		{
			$.messager.alert('错误提示','请先右键复制一条记录!',"error");
            return;
		}		
		if(copyFlag == 1)	//（从父表复制结构化结果）
		{
			if(dataContainer.rows.length==0){
				$.messager.alert('错误提示','复制数据的结构化'+sourceDesc+'为空!',"error");
				return;				
			}
            for(var i = 0;i < dataContainer.rows.length; i++){
                //alert(i)
                var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
                var MKBSDStructResultID = dataContainer.rows[i].MKBSDStructResultID
                //alert(MKBSDStructResultID)
                var MKBSDStructResult = dataContainer.rows[i].MKBSDStructResult
                var MKBSDTermDR = dataContainer.rows[i].MKBSDTermDR
                var MKBSDSupplement = dataContainer.rows[i].MKBSDSupplement
                //判断是否存在同名（诊断模板id相同）的数据...结果传空或者是有的话传id和他的描述
                var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justHasExist",parId,MKBSDTermDR);
                //alert(1111+"*"+existStr)
                if(existStr != ""){
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,existStr.split("^")[0],MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}					
                    //加载右侧数据    
                    $('#mygrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBStructuredData",
                        QueryName:"GetResultList",
                        id:$('#leftgrid').datagrid('getSelected').Rowid
                    }); 
                }else{
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
					var data=eval('('+result+')');
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
                }
				
                
                //加载右侧数据    
                $('#mygrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.MKB.MKBStructuredData",
                    QueryName:"GetResultList",
                    id:$('#leftgrid').datagrid('getSelected').Rowid
                });                  
            }            
        }
		else if(copyFlag==2){//粘贴单条（从子表复制结构化结果）
			var parId = ($('#leftgrid').datagrid('getSelected')).Rowid
			var MKBSDStructResultID = dataContainer.MKBSDStructResultID
			//alert(MKBSDStructResultID)
			var MKBSDStructResult = dataContainer.MKBSDStructResult
			var MKBSDTermDR = dataContainer.MKBSDTermDR
			var MKBSDSupplement = dataContainer.MKBSDSupplement
			var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justHasExist",parId,MKBSDTermDR);
			if(existStr != ""){
				var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,existStr.split("^")[0],MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
				var data=eval('('+result+')');
				if(data.success == 'true'){
					refreshResultcolumn();//刷新左侧结构化字段
				}
				//加载右侧数据    
				$('#mygrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBStructuredData",
					QueryName:"GetResultList",
					id:$('#leftgrid').datagrid('getSelected').Rowid
				}); 
			}else{
				var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",parId,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
				var data=eval('('+result+')');
				if(data.success == 'true'){
					refreshResultcolumn();//刷新左侧结构化字段
				}
			}             
			//加载右侧数据    
			$('#mygrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				QueryName:"GetResultList",
				id:$('#leftgrid').datagrid('getSelected').Rowid
			});                      
		}else if(copyFlag==3){//粘贴icd
			//if(dataContainer.MKBSDMDr=="")
			if(dataContainer.MKBSDICD=="")
			{
				$.messager.alert('错误提示','复制数据的icd为空!',"error");
				return;		
			}
			
			var ICDRecord = $('#leftgrid').datagrid('getSelected')
			var MKBSDMDr = dataContainer.MKBSDMDr;	//MRC指向
			var MKBSDMrc = dataContainer.MKBSDMrc;	//ICD描述
			var MKBSDICD = dataContainer.MKBSDICD;	//ICD
			var resultIndex = $('#leftgrid').datagrid('getRowIndex',ICDRecord)
			var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",ICDRecord.Rowid,"",MKBSDICD,MKBSDMrc,"","","");//1
			var data=eval('('+result+')');
			if(data.success=='true'){
				//后台修改全文索引
				//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",STBBase,ICDRecord.MKBSDICD,ICDRecord.Rowid);
				//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",STBBase,dataContainer.MKBSDICD,ICDRecord.Rowid);
			}
			$('#leftgrid').datagrid('getRows')[resultIndex].Rowid = data.id;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMDr = MKBSDMDr;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMrc = MKBSDMrc;
			$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDICD = MKBSDICD;
			$('#leftgrid').datagrid('refreshRow',resultIndex)
			loadViewTr(ICDRecord);
		}else if(copyFlag==4){//粘贴科室
			if(dataContainer.MKBSDLocs==""){
				$.messager.alert('错误提示','复制数据的专业科室为空!',"error");
				return;					
			}
			var locRecord=$('#leftgrid').datagrid('getSelected')//将要复制到的行
			var MKBSDLocs=locRecord.MKBSDLocs
			var MKBSDLocStr=locRecord.MKBSDLocStr
			var arr=dataContainer.MKBSDLocs.split(',')//被复制的科室
			if(locRecord.MKBSDLocs!=""){
				var MKBSDLocsO=","+locRecord.MKBSDLocs+","
				var k = 0;
				for(var i=0;i<arr.length;i++){//判断是否已经存在需要复制的id
					var arrO=","+arr[i]+","
					if(MKBSDLocsO.indexOf(arrO)<0){
						if(k==0){
							MKBSDLocs = locRecord.MKBSDLocs+","+arr[i]
							var desc=(dataContainer.MKBSDLocStr).split(',')[i]
							MKBSDLocStr=locRecord.MKBSDLocStr+","+desc	
							k++;						
						}else{
							MKBSDLocs = MKBSDLocs+","+arr[i]
							var desc=(dataContainer.MKBSDLocStr).split(',')[i]
							MKBSDLocStr=MKBSDLocStr+","+desc							

						}

						//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",desc,locRecord.Rowid+"L");
					}
				}
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",locRecord.Rowid,"","","","","",MKBSDLocs);//1
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',locRecord)
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocs = MKBSDLocs;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocStr = MKBSDLocStr;
				$('#leftgrid').datagrid('refreshRow',resultIndex)
			}else{
				/*for(var i=0;i<arr.length;i++){
					var desc=(dataContainer.MKBSDLocStr).split(',')[i]
					tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",desc,locRecord.Rowid+"L");
				}*/
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",locRecord.Rowid,"","","","","",dataContainer.MKBSDLocs);//1
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',locRecord)
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocs = dataContainer.MKBSDLocs;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocStr = dataContainer.MKBSDLocStr;
				$('#leftgrid').datagrid('refreshRow',resultIndex)
			}

			//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",nodes[j].text,records[i].Rowid+"L");
		}
	 }
	 //合并方法
	 combineBtn = function(){
		var records =  $('#leftgrid').datagrid('getChecked')
		var record = $('#leftgrid').datagrid('getSelected')
		var markid=record.Rowid;
		var markresult=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetChildIdString",markid);
		var markicd=record.MKBSDICD;
		var indexarr = []//保存前台被删除数据的索引
		var j = 0
		//var temDesc=""//保存一个临时描述
		var successflag="";
		var ids = ""
		var dias = ""
		var pys = ""
		var icds = ""
		for(var i = 0; i < records.length; i++){
			var py=Pinyin.GetJPU(records[i].MKBSDDiag)
			//获取结构化子表id
			var conmarkresult =tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetChildIdString",records[i].Rowid);
			//con1 全部相同（结构化和icd）  con2 全为空  con3 con4一个为空，剩下的相同
			var con1 = records[i].Rowid!=markid && records[i].MKBSDICD == markicd && conmarkresult==markresult
			var con2 = records[i].Rowid!=markid && records[i].MKBSDICD == "" &&  conmarkresult == ""
			var con3 = records[i].Rowid!=markid && records[i].MKBSDICD == markicd &&  conmarkresult == ""
			var con4 = records[i].Rowid!=markid && records[i].MKBSDICD == "" &&  conmarkresult == markresult
			if(con1||con2||con3||con4){
				//保存到其他描述
				/*var data=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","OtherUpdate",markid,"",records[i].MKBSDDiag,"",py,"OD");
				var data=eval('('+data+')');
				if(data.success == 'true'){
					//修改父表合并标志
					var datao=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",records[i].Rowid,"",records[i].MKBSDMDr,"","C","");//1
					var datao=eval('('+datao+')');
					if(datao.success == 'true'){
						var dataoo=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveCopyOther",records[i].Rowid,markid);
						successflag  = "Y"
						var index = $('#leftgrid').datagrid('getRowIndex',records[i]);
						indexarr[j] = index
						j++;
					}
				}*/
				if(ids == ""){
					ids = records[i].Rowid
					dias = records[i].MKBSDDiag
					pys = py
					icds = records[i].MKBSDICD
				}else{
					ids = ids + "," + records[i].Rowid
					dias = dias + "," + records[i].MKBSDDiag
					pys = pys + "," + py
					icds = icds + "," + records[i].MKBSDICD
				}
				var index = $('#leftgrid').datagrid('getRowIndex',records[i]);
				indexarr[j] = index
				j++;
			}
		}
		if(ids!=""){
			var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","AllOtherData",markid,ids,dias,pys,icds)
			if(result==1){
				successflag="Y"
			}
			
		}
		if(successflag=="Y"){
			$('#leftgrid').datagrid('clearChecked');
			$("#leftgrid").datagrid('uncheckAll');
			setTimeout(function(){
				$('#leftgrid').datagrid("reload")
			},50)	
			$.messager.popover({msg: '数据合并到<font color=red>'+record.MKBSDDiag+'</font>成功！',type:'success',timeout: 2000}); 
		}else{
			$.messager.alert('错误提示','请先检查结构化结果和ICD是否符合合并规则!',"error");
		}
		//if(temDesc!=""){
		/*var tipDesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetOtherDesc",record.Rowid,"OD");
		var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
		$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDOOther = tipDesc;
		$('#leftgrid').datagrid('refreshRow',resultIndex)  */
		//}
		 		
		//全部删除完后，在前台界面倒叙删除数据
		/*for(var i = indexarr.length-1;i>=0;i--){
			//alert(i)
			$('#leftgrid').datagrid('deleteRow',indexarr[i]);
		}*/

	 }

	 /**********************************************复制粘贴功能结束****************************************/
	 /**********************************************子表****************************************/
	 
	var firstflag = "first";//判断是否是默认加载第一项的标志
	var firstid = "";//保存操作项id
    var columns =[[
        //{field:'ck',checkbox:true},
        {field:'Rowid',title:'rowid',sortable:true,width:100,hidden:true},  
        {field:'MKBSDStructResultID',title:'结构化结果ID',sortable:true,width:100,hidden:true},
        {field:'MKBSDStructResult',title:'结构化结果',sortable:true,width:100,
            formatter:function(value,row,index){
				if(row.MKBTActiveFlag=="N"){
					var content = '<font color=#666>'+sourceDesc+(index+1)+':</font>&nbsp&nbsp'+'<font color=red>'+value+'</font>'; //green
				}else{
					var content = '<font color=#666>'+sourceDesc+(index+1)+':</font>&nbsp&nbsp'+value;
				}
                return content;
            }
        },
        {field:'MKBSDTermDR',title:'术语ID',sortable:true,width:100,hidden:true},
		{field:'MKBSDSupplement',title:'补充'+sourceDesc,sortable:true,width:100,hidden:true},
		{field:'MKBSDSequence',title:'顺序',sortable:true,width:100,
			sorter:function (a,b){  
				if(a.length > b.length) return 1;
					else if(a.length < b.length) return -1;
					else if(a > b) return 1;
					else return -1;
			},hidden:true

		},
		{field:'MKBTActiveFlag',title:sourceDesc+'是否激活',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        columns: columns,  //列信息
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        showHeader:false,//不显示表头
        ClassTableName:'User.MKBStructuredData',
		SQLTableName:'MKB_StructuredData',
		idField:'Rowid',
		sortName : 'MKBSDSequence',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$(this).datagrid('columnMoving');
			//默认选中第一项
			setTimeout(function(){
				if(data.rows.length!=0 && firstflag=="first"){
					if(data.rows[0].MKBTActiveFlag!="N"){						
							$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
							$('#mygrid').datagrid('selectRow',0);
							var flag = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","JustTermClose",data.rows[0].MKBSDTermDR)
							if(flag != "N"){
								SelPropertyData="";
								refreshRightPanel();
								$("#Form_DiagDesc").val(data.rows[0].MKBSDStructResult)
								$("#div-img").hide();			
							}else{
								var ccc = $('#combogrid')
								LoadDiagnosData("",ccc);
								$('#combogrid').combogrid('setValue',''); 
								$("#div-img").show();
							}
						
					}	
				}else if(data.rows.length!=0 && firstflag == "up"){
					var index=$('#mygrid').datagrid('getRowIndex',firstid);  
					$('#mygrid').datagrid('selectRow',index);

				}
			},200)
        },
        onClickRow:function(rowIndex,row)
        {
			//copyToCommand(row.MKBSDStructResult)
			if(row.MKBTActiveFlag=="N"){
				$.messager.alert('提示','数据已封闭!',"error");
				return;	
			}
			SelPropertyData="";
            refreshRightPanel();
			$("#Form_DiagDesc").val(row.MKBSDStructResult)
			$("#div-img").hide();
        },
        onDblClickRow:function(rowIndex, field, value)
        {         
        }, 
		onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
			//右键菜单
			var $clicked=$(e.target);
			textForCopy =$clicked.text()||$clicked.val()   //普通复制功能
			
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmmm = $('<div style="width:150px;"></div>').appendTo('body');
            $(
				'<div onclick="refreshRelation(2)" iconCls="icon-resort" id="orbtn">OR</div>'+
				'<div onclick="refreshRelation(1)" iconCls="icon-resort" id="andbtn">AND</div>'+

				'<div onclick="copyToCommand()" iconCls="icon-copyorder" data-options="">复制文本</div>'+
                '<div onclick="DelDataM()" iconCls="icon-cancel" data-options="">删除</div>' +
				'<div onclick="copyResultCBtn()" iconCls="icon-copyorder" data-options="">复制结构化'+sourceDesc+'</div>'+
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
	refreshRelation = function(flagt){
		if(flagt == 1){
			var flag="AND"
		}else if(flagt == 2){
			var flag="OR"
		}
		var record =  $('#leftgrid').datagrid('getSelected');
		if(record){
			if($('#mygrid').datagrid('getData').rows.length<2){
				$.messager.alert('错误提示','仅一条结构化'+sourceDesc+'，请查看!',"error");
				return;	
			}
			var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveResultRelation",record.Rowid,flag);
			var data=eval('('+result+')');
			if(data.success=='true'){   
				$.messager.popover({msg: '设置成功!',type:'success',timeout: 1000});
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDResultRelation = flag;
				$('#leftgrid').datagrid('refreshRow',resultIndex);	
			} 	
		}else{
			$.messager.alert('错误提示','请先在左侧列表选择一条记录!',"error");
			return;
		}
	}

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
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			MethodName:"SaveDragOrder",
			order:order
			},function(txtData){
		});

		refreshResultcolumn();//刷新左侧结构化字段


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
	
    //ShowUserHabit('mygrid');//保存用户习惯
    //查询按钮
    $('#hispartsearch').click(function(e){
		searchFunLibData("")
	})
	//匹配查询框
	$("#TextMate").combobox({
		valueField:'id',
		textField:'text',
		panelWidth:150,
		data:[
			{id:'A',text:'全部'},
			{id:'B',text:'结构化'+sourceDesc+'已匹配'},
			{id:'D',text:'结构化'+sourceDesc+'未匹配'},
			{id:'E',text:'ICD编码已匹配'},
			{id:'C',text:'ICD编码未匹配'},						
			{id:'F',text:'全局化词表已匹配'},
			{id:'G',text:'全局化词表未匹配'}
						
		],
		value:'A',
        onSelect: function(record){
            searchFunLibData("");
        }
	});	

	//科室下拉框
	$('#TextLoc').combotree({
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=GetTreeJson&base="+locbaseID,
		multiple:false,
		cascadeCheck:false,
		panelWidth:230,
		onSelect: function(record){
			//console.log(record)
            searchFunLibData(record.text);
        }
	})
	//实际科室下拉框
	$('#TextRLoc').combobox({
		url:$URL+"?ClassName=web.DHCBL.MKB.MKBStructuredBase&QueryName=GetLocList&ResultSetType=array&stbbase="+STBBase,
		valueField:'MKBTRowId',
		textField:'MKBTDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		cascadeCheck:false,
		panelWidth:230,
		onSelect:function(){
			$('#TextSort').combobox('setValue',0);
		}
	})
    //搜索回车事件
	$('#TextICD,#TextGen,#TextFreMin,#TextFreMax,#TextCenter').keyup(function(event){
		if(event.keyCode == 13) {
			searchFunLibData("");
		}
	}); 	
	//单机选中文本内容方法
	Myselect_txt = function(obj){
		if($(obj).focus()){

			$(obj).select();
		}
	}
    searchFunLibData = function(loctext){
    	if(sourceflag=="Operation")		//手术
        {
        	var valbox = $HUI.panel("#myPanel",{
				headerCls:'panel-header-gray',
				title:"手术描述"			
			});
        }
        else
        {
        	var valbox = $HUI.panel("#myPanel",{
				headerCls:'panel-header-gray',
				title:"诊断"			
			});
        }
        var centerword=$('#TextCenter').val();
    	//var user=$('#TextUser')..val();
		var diag = $('#TextGen').val();
		var icd = $('#TextICD').val();
		if(loctext==""){
			var loc = $('#TextLoc').combotree('getText');
		}else{
			var loc = loctext
		}
		var status = $('#TextStatus').combobox('getValue');
		//var reason = $('#TextReason').combobox('getValue');
		var fremin = $('#TextFreMin').val();
		var fremax = $('#TextFreMax').val();
		var sort = $('#TextSort').combobox('getValue');
		var types = $('#TextDiaSort').combobox('getText');

		var typesArry = $('#TextDiaSort').combobox('getValues');
        var types = typesArry.join(',');

		var match = $('#TextMate').combobox('getValue');
		var locflag = $('#TextLocMark').combobox('getValue');
		
		var rloc = $('#TextRLoc').combobox('getText');
		/*if(mark == "全部"){
			mark = "" 
		}*/
		if(fremin == "")
		{
			fre = 0;
		}
		if((fremin-0)>(fremax-0) && fremax !="")
		{
            $.messager.alert('错误提示','最大值不能小于最小值!',"error");
            return;			
		}
		if(isNaN(fremin) || isNaN(fremax))
		{
            $.messager.alert('错误提示','请输入有效值!',"error");
            return;				
		}
        $('#leftgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            MethodName:"GetNewList",
            diag:diag,
            icd:icd,
            loc:loc,
			status:status,
			minfre:fremin,
			maxfre:fremax,
			sort:sort,
			types:types,
			match:match,
			basedr:STBBase,
			rloc:rloc,
			centerword:centerword/*,
			user:user*/
			//reason:reason
        });
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetResultList",
            id:"-1"
		});    
		$("#mygrid").datagrid('unselectAll');	

        $("#leftgrid").datagrid('unselectAll');
        $("#leftgrid").datagrid('uncheckAll');
		$('#combogrid').combogrid('setValue',''); 
		var newarray = new Array();
		$("#div-img").show();
      
        $('.view2').remove();
        $('.trView').remove();
		$('.view3').remove();  
		$('.viewicd10').remove();
		$('.viewicd').remove();
		//$('.Initial_ICD').remove();
		//$('#centerLocGrid').datagrid('loadData',newarray);//清空频次
		$('#centerLocGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetLocList",
            id:"-1"
        });  

	}
    //处理状态查询框
    $("#TextStatus").combobox({
        valueField:'id',
		textField:'text',
		panelWidth:150,
        data:[
			{id:'',text:'全部'},
            {id:'Y',text:'已处理'},
			{id:'N',text:'未处理'},
			{id:'P',text:'预处理'},
			{id:'G',text:'放弃'},
			//{id:'X',text:'上报待处理'},
			{id:'O',text:'已审核'}
        ],
        value:'',
        onSelect: function(record){
            searchFunLibData("");
        }
	})
	//上报理由查询框
    /*$("#TextReason").combobox({
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
            searchFunLibData("");
        }
	})*/	

	//类型查询框
	$("#TextDiaSort").combobox({
        valueField: 'id',
        textField: 'text',
        //multiple: true,
        //rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: true,
        data: [{
            id: '1',
            text: '中医诊断'
        }, {
            id: '2',
            text: '中医证型'
        }, {
            id: '3',
            text: '肿瘤形态学编码'
        }, {
            id: '4',
            text: '损伤中毒外部原因'
        }, {
            id: '5',
            text: '西医诊断'
        }]
    });
	/*$("#TextDiaSort").combobox({
		valueField:'id',
		textField:'text',
		panelWidth:150,
		data:[
		],
        //url:$URL+"?ClassName=web.DHCBL.MKB.MKBStructuredData&QueryName=GetSourceComList&ResultSetType=array",
        //valueField:'MKBTRowid',
		//textField:'MKBTDesc',
		panelWidth:150,		
        onSelect: function(record){
            searchFunLibData("");
        }
	});*/
	//加载数据来源下拉框数据
	/*var sourcearr = new Array();
	sourcearr.push({"id":'0',"text":'全部'})
	if(sourcedata != ""){
		for(var i = 0; i < sourcedata.split(",").length; i++){
			sourcearr.push({"id":i+1,"text":sourcedata.split(',')[i]});
		}
	}
	$("#TextDiaSort").combobox('loadData',sourcearr);
*/
	//排序方式下拉框
    $("#TextSort").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'0',text:'频次'},
			{id:'1',text:'拼音码'},
			{id:'2',text:'RowID'},
			{id:'3',text:'ICD'},
			{id:'4',text:'中心词'}
        ],
        value:'3',
        onSelect: function(record){
            searchFunLibData("");
        }
	})	
	//科室标识
	$("#TextLocMark").combobox({
		valueField:'id',
		textField:'text',
		data:[
			{id:'R',text:'实际科室'},
			{id:'P',text:'专业科室'}
		],
		onSelect: function(record){
			//searchFunLibData();
		}
	})
     //清屏
    $('#hispartRefresh').click(function(e){
		clearLeftData();
	})  
	clearLeftData = function(){
		$('#TextCenter').val('');
        $('#TextGen').val('');
        $('#TextICD').val('');
		$('#TextLoc').combotree('setValue','');
		$('#TextFreMin').val('');
		$('#TextFreMax').val('');
		$('#TextDiaSort').combobox('setValue','');
		$('#TextLocMark').combobox('setValue','');
		$('#TextMate').combobox('setValue','A');
		$('#TextRLoc').combobox('setValue','');
		var sort = $('#TextSort').combobox('getValue');
		$('#TextStatus').combobox('setValue','');
		//$('#TextReason').combobox('setValue','');
        $('#leftgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            MethodName:"GetNewList",
            //loc:"心内科",
			status:"",
			//user:"default",//默认显示全部
			sort:sort,//在清屏时不更换排序方式
			mark:"",
			match:"A",
			basedr:STBBase
        });
        if(sourceflag=="Operation")		//手术
        {
        	var valbox = $HUI.panel("#myPanel",{
			headerCls:'panel-header-gray',
			title:"手术描述"			
		});
        }
        else
        {
        	var valbox = $HUI.panel("#myPanel",{
			headerCls:'panel-header-gray',
			title:"诊断"			
		});
        }
        
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetResultList",
            id:"-1"
        });          
        $("#leftgrid").datagrid('unselectAll');
        $("#leftgrid").datagrid('uncheckAll');
		$('#combogrid').combogrid('setValue',''); 
		var newarray = new Array();
		var arrayRecord = $('#leftgrid').datagrid('getSelected');
        $('.view2').remove();
        $('.trView').remove();
		$('.view3').remove();
		$('.viewicd10').remove();
		$('.viewicd').remove();
		//$('.Initial_ICD').remove();
		//$('#centerLocGrid').datagrid('loadData',newarray);//清空频次
		$('#centerLocGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetLocList",
            id:"-1"
        }); 
		$("#div-img").show();
	}  
    //数据导入按钮
   /* $("#btnLoad").click(function(e){
        $("#myWin").show();
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-upload',
            resizable:true,
            title:'上传',
            modal:true
        });
    })*/
    ///删除结构化结果
    var DELETE_Result_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=DeleteStructResult";
    DelDataM=function()
    {       
		var record = $('#leftgrid').datagrid('getSelected')           
		if(record.MKBSDStatus=="O"){
			$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
			return;
		}
        //更新
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
								 //刷新父表单元格
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                 $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
                                 $('#combogrid').combogrid('setValue','');
								 $("#div-img").show();
								 refreshResultcolumn();//刷新左侧结构化字段
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
        temp=row.MKBSDStatus;
        row.MKBSDStatus=row.MKBSDStatusF;
        row.MKBSDStatus=temp;
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
                if((rowsvalue.MKBSDStatus!="")){
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
        //alert(record.MKBSDStatus)
        var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",record.Rowid,record.MKBSDStatus,"","","","",record.MKBSDLocs);//1
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
    //下拉列表（诊断）
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
            {field:'MKBTDesc',title:sourceDesc+'名称',width:200,sortable:true,
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
            {field:'MKBTCode',title:sourceDesc+'代码',width:120,sortable:true,hidden:true},
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
    }
    //加载combogrid数据
    function LoadDiagnosData(q,obj)
    {
    	//2021  zybase  xybase
    	
        var desc=q;
        var opts = obj.combogrid("grid").datagrid("options");
        var queryParams = new Object(); 
        //queryParams.ClassName="web.DHCBL.MKB.MKBTermProDetail"; 
        //queryParams.QueryName="GetTermListForDoc";
        queryParams.rowid ="";
        if (TCMDiagFlag=="Y")
        {
        	queryParams.base =zybase;
        }
        else
        {
        	queryParams.base =xybase;
        }
        
		queryParams.desc =desc;
        //opts.url = $URL  
        //opts.queryParams = queryParams;
        opts.url ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTermListForDoc"
        opts.queryParams = queryParams;
        //reload 等同于'load'方法，但是它将保持在当前页。
        obj.combogrid("grid").datagrid("load");
    }
   
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
		CacheDiagPropertyData={};
		CacheDiagPropertyDataNote={};	
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
						for ( var oe in CacheDiagPropertyData) {
							if (proFrequencyStr.indexOf("$"+oe+"$")<0){
								listArr.push({"id":oe,"text":CacheDiagPropertyData[oe],"note":CacheDiagPropertyDataNote[oe]});
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
						if (showType=="G"){ //列表
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
					CacheDiagPropertyData={};
					CacheDiagPropertyDataNote={};
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
				for ( var oe in CacheDiagPropertyData) {

					listArr.push({"id":oe,"text":CacheDiagPropertyData[oe],"note":CacheDiagPropertyDataNote[oe]});
					
				}
				$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
				$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');
			},700)//---石萧伟加延时


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
					if(record && (($("#combogrid").combogrid('getValue')==record.MKBSDTermDR))){//石萧伟
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
				CacheDiagPropertyData={};
				CacheDiagPropertyDataNote={};
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
					}
				}
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
		var TreeCheckedIdStr="",ComboCheckedIdStr="",RadioCheckedIdStr="",CheckBoxCheckedIdStr="",GridCheckedIdStr=""//列表
		//石萧伟
		if ((Rowid!="")){ //属性修改
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				
				var parentid=$("#leftgrid").datagrid("getSelected").Rowid;//石萧伟
				var ret=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetData",parentid,Rowid);//石萧伟
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
			GridCheckedIdStr = ret.split("^")[4];//列表
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
					//列表
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
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val($("#mygrid").datagrid("getSelected").MKBSDSupplement)
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){//哈哈
									//根据SDSRowId修改补充诊断
			 						$.ajax({
										url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
										data:{
											"Cid":Rowid,     ///rowid
											"Supplement":$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
										},  
										type:"POST",   
										success: function(data){
												  var data=eval('('+data+')'); 
												  if (data.success == 'true') {
												  	  //UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
												  	  if ($("#mygrid").datagrid("getSelected").MKBSDSupplement!=""){
												  	  		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove")
												  	  }
												  	  ifFirstLoadPropertyData=false;
												  	  if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
												  	 		SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
												  	  }
												  } 
												  else { 
														var errorMsg ="补充"+sourceDesc+"保存失败！"
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
							
							if ($("#mygrid").datagrid("getSelected")&&($("#mygrid").datagrid("getSelected").MKBSDSupplement!="")&&(($("#mygrid").datagrid("getSelected").MKBSDSupplement!=undefined))){
								SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#mygrid").datagrid("getSelected").MKBSDSupplement,$("#mygrid").datagrid("getSelected").MKBSDSupplement,"add")
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
																/*var height=parseInt(window.screen.height)-120;
																var width=parseInt(window.screen.width)-50;
																if (isTOrP=="P"){
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+MRCICDRowid+"&ProId="+childId+"&detailId="+node.id; 
																}else{
																	var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+termmenuid+"&TermID="+node.id+"&ProId="; 
																}
																var listtermWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ listtermWin.document.title = '知识点'; }, 150)*/

																var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
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
																	if(isTOrP=="P"){
																		window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+MRCICDRowid+"&ProId="+childId+"&detailId="+node.id,parentid,menuimg)
																	}else{
																		var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																		window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+termmenuid+"&TermID="+node.id+"&ProId=",parentid,menuimg)
																	}
																	
																/*}else{
																	if(isTOrP=="P"){
																		parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+node.id+"&ProId="+childId+"&detailId="+node.id,menuimg);
																	}else{
																		var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																		parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+termmenuid+"&TermID="+node.id+"&ProId=",menuimg);
																	}
																}*/
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
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
							data:{
								"Cid":Rowid,     ///rowid
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
				//$.ajax({
				//	url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
					//data:{
					//	"Cid":$("#mygrid").datagrid("getSelected").Rowid,     ///rowid
						//"Supplement":""
					//},  
					//type:"POST",   
					//success: function(data){
							 // var data=eval('('+data+')'); 
							  //if (data.success == 'true') {
									//UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);	
								  var MKBSDSupplement = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
							  	  $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val("")
							  	  ifFirstLoadPropertyData=false;
							  	  SaveSelPropertyData(index,"selpro"+trId,childDesc,MKBSDSupplement,"","remove")
							//   } 
							//   else { 
							// 		var errorMsg ="补充诊断保存失败！"
							// 		if (data.info) {
							// 			errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							// 		}
							// 		$.messager.alert('操作提示',errorMsg,"error");
							// }			
					//}  
				//})
			}else{
				var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',id); 
				$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node.target);
			}
		}
		if (showtype=="C"){ //下拉框
			$("#"+childId+"_C"+isTOrP+"").combobox('setValue', "");
		}
		if (showtype=="G"){ //列表
			var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",id)
			$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
		}
		if (showtype=="CB"){ //单选框
			$("#"+childId+"_"+id+"_CB"+isTOrP+"").prop('checked','');
			SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
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
			for (var i=0; i <data.rows.length; i++) { //石萧伟从1改0，暂时没发现对操作的影响
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
				if (showtype=="G"){ //列表
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
		var GridCheckedIdStr=""//列表
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
					//列表
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
					//列表
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
		CacheDiagPropertyData={};
		CacheDiagPropertyDataNote={};
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
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
										CacheDiagPropertyData[trids+"#"+TextDetailId]=TextDetailDesc; //cache
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
										CacheDiagPropertyData[trids+"#"+ComboId]='<span class="hisui-tooltip" title="'+ComboRemark+'">'+ComboText+'</span>'//ComboText; //cache
									}else{
										CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									}*/
									CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									if (ComboRemark!=""){
										CacheDiagPropertyDataNote[trids+"#"+ComboId]=ComboRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{//检索条件为空
								CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
								if (ComboRemark!=""){
									CacheDiagPropertyDataNote[trids+"#"+ComboId]=ComboRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTRowId ;
							var ComboText=ComboData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (ComboText.indexOf(SearchText)>=0){
									CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{
								CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
							}
						}
					}
				}
				//列表
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
									CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
									if (GridRemark!=""){
										CacheDiagPropertyDataNote[trids+"#"+GridId]=GridRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{//检索条件为空
								CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
								if (GridRemark!=""){
									CacheDiagPropertyDataNote[trids+"#"+GridId]=GridRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTRowId ;
							var GridText=GridData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (GridText.indexOf(SearchText)>=0){
									CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{
								CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
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
								CacheDiagPropertyData[trids+"#"+radioId.split("_")[1]]=radioText; //cache
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
							CacheDiagPropertyData[trids+"#"+radioId.split("_")[1]]=radioText; //cache
							/*$("#"+radioId+"").css("display","");
						    $("#"+radioId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
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
								CacheDiagPropertyData[trids+"#"+checkboxId.split("_")[1]]=checkboxText; //cache
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
							CacheDiagPropertyData[trids+"#"+checkboxId.split("_")[1]]=checkboxText;
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
	                        	CacheDiagPropertyData[trids+"#"+node["id"]]='<span class="hisui-tooltip" title="'+remark+'">'+text+'</span>' //text; //cache
	                        }else{
	                        	CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
	                        }*/
	                        CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
	                        if (remark!=""){
	                        	CacheDiagPropertyDataNote[trids+"#"+node["id"]]=remark; //cache
	                        }
	                    } 
                   	}else{//检索条件为空
                   		var text=node.text.split("<span class='hidecls'>")[0];
                        var remark=node.text.split("^")[3].split("</span>")[0]
                        CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
                        if (remark!=""){
                        	CacheDiagPropertyDataNote[trids+"#"+node["id"]]=remark; //cache
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
			if(record.MKBSDStatus=="O"){
				$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
				return;
			}
            var rowid = record.Rowid;
            var MKBSDStatus = record.MKBSDStatus;
			
			var MKBSDTermDR=propertyValue.split("#")[0];
			var MKBSDStructResultID=propertyValue.split("#")[1];

			var MKBSDSupplement=propertyValue.split("#")[2];
			var resultRequired=propertyValue.split("#")[3]; //必填项未维护结果集 
			var MKBSDStructResult ="";
			
			var termidforjust=$('#combogrid').combogrid('getValue')
			if (termidforjust==""||termidforjust==undefined){
				$.messager.alert('错误提示',sourceDesc+'不能为空!',"error");
				return;
			}
			//判断获取到的下拉框的值是否正确，防止保存上一条记录的数据
			var IdExsit=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justIdExist",termidforjust);
			if(termidforjust != "" && IdExsit==""){
				$.messager.alert('错误提示','请在下拉框选择一条正确的'+sourceDesc+'!',"error");
				return;
			}


            if(flag == 1) {
                var cord=$("#mygrid").datagrid("getSelected");
                if(cord){
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",rowid,cord.Rowid,MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
					var data=eval('('+result+')');
					firstflag = "up";//判断是否是默认加载第一项的标志
					firstid = data.id;//保存操作项id				
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
					/*var refreshdesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetChiForStrucIDs",MKBSDStructResultID,MKBSDTermDR);
					if(MKBSDSupplement!=""){
						var SupplementDesc="("+MKBSDSupplement+")"
						refreshdesc = refreshdesc.split("]")[0]+SupplementDesc+"]"
					}*/
                }else{
                        $.messager.alert('错误提示','请先选中一条'+sourceDesc+'!',"error");
				} 
            } else if(flag == 2){
                //如果是新增要判断有没有同名诊断
				var existStr = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justHasExist",rowid,MKBSDTermDR);
                if(existStr != ""){ 
					$("#xWin").show();
					$("#xwin_div").html("")
					$("#xwin_div").append('已经存在同名'+sourceDesc+'<font color=red>'+ existStr.split('^')[1]+'</font>确定要替换吗?')
					var myWin = $HUI.dialog("#xWin",{
						resizable:true,
						title:'同名'+sourceDesc,
						modal:true,
						buttonAlign : 'center',
						buttons:[{
							text:'替换',
							id:'save_btn',
							handler:function(){
								var childId = existStr.split('^')[0]; 
								var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",rowid,childId,MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
								var data=eval('('+result+')');
								firstflag = "up";//判断是否是默认加载第一项的标志
								firstid = data.id;//保存操作项id							
								if(data.success == 'true'){
									refreshResultcolumn();//刷新左侧结构化字段
								}
								$('#mygrid').datagrid('load',  { 
									ClassName:"web.DHCBL.MKB.MKBStructuredData",
									QueryName:"GetResultList",
									id:record.Rowid
								});
								$('#xWin').window('close');

								setTimeout(function(){
									var dataarr = $("#mygrid").datagrid("getData");
									if(dataarr.rows.length!=0){
										var text=dataarr.rows[0].MKBSDStructResult
									}else{
										var text=""
									}
								 	var resultIndex = $('#leftgrid').datagrid('getRowIndex',$("#leftgrid").datagrid('getSelected'))
								 	$('#leftgrid').datagrid('getRows')[resultIndex].Result = text;
								 	$('#leftgrid').datagrid('refreshRow',resultIndex) 									
								},100) 							
							}
						},{
							text:'新增',
							handler:function(){
								var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",rowid,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
								var data=eval('('+result+')');
								firstflag = "up";//判断是否是默认加载第一项的标志
								firstid = data.id;//保存操作项id							
								if(data.success == 'true'){
									refreshResultcolumn();//刷新左侧结构化字段
								}
								$('#mygrid').datagrid('load',  { 
									ClassName:"web.DHCBL.MKB.MKBStructuredData",
									QueryName:"GetResultList",
									id:record.Rowid
								});
								$('#xWin').window('close');
							}
						}]
					});					
                } else{
					var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",rowid,"",MKBSDStructResultID,MKBSDStructResult,MKBSDTermDR,MKBSDSupplement);
					var data=eval('('+result+')');
					firstflag = "up";//判断是否是默认加载第一项的标志
					firstid = data.id;//保存操作项id				
					if(data.success == 'true'){
						refreshResultcolumn();//刷新左侧结构化字段
					}
					/*var refreshdesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetChiForNewSeqStrucIDs",MKBSDStructResultID,MKBSDTermDR);
					if(MKBSDSupplement!=""){
						var SupplementDesc="("+MKBSDSupplement+")"
						refreshdesc = refreshdesc.split("]")[0]+SupplementDesc+"]"
					}
					if(record.Result == ""){
						tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",record.Rowid,"","",1,"",record.MKBSDLocs);
						var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
						$('#leftgrid').datagrid('getRows')[resultIndex].Result = refreshdesc;
						$('#leftgrid').datagrid('refreshRow',resultIndex)
					}*/	
                }              
                     
            }         
                              

            //$('#leftgrid').datagrid('reload'); //刷新列表
            $('#mygrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBStructuredData",
                QueryName:"GetResultList",
                id:record.Rowid
            });            	
        }else{
            $.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
        }       
	}
	//刷新左侧结构化字段
	refreshResultcolumn=function(){
		
		//setTimeout(function(){
			//前台获取第一条数据
			var record = $("#leftgrid").datagrid('getSelected');
			var ANDOR = record.MKBSDResultRelation;
			var resultDesc = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetAllResultData",record.Rowid)

			//自动更新ANDOR字段
			if(resultDesc.split("<br/>").length>1 && record.MKBSDResultRelation == ""){
				//如果结构化结果多余两条，并且没有维护ANDOR，则自动设置为AND
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveResultRelation",record.Rowid,"AND");
				var data=eval('('+result+')');
				if(data.success == 'true'){
					ANDOR = "AND"
				}
			}else if(resultDesc.split("<br/>").length<2 && record.MKBSDResultRelation != ""){
				//如果结构化结果少于两条，并且维护了ADNOR，则自动清空关系
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveResultRelation",record.Rowid,"");
				var data=eval('('+result+')');
				if(data.success == 'true'){
					ANDOR = ""
				}
			}
			
			 var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
			 $('#leftgrid').datagrid('getRows')[resultIndex].Result = resultDesc;
			 $('#leftgrid').datagrid('getRows')[resultIndex].MKBSDResultRelation = ANDOR;
			 $('#leftgrid').datagrid('refreshRow',resultIndex) 									
		//},500) 								
	}
    //点击提交后刷新右侧数据
    refreshRightPanel=function(){
		PreSearchText = "";//清空检索框   石萧伟20190827
        var record=$("#mygrid").datagrid("getSelected");
        var ccc=$('#combogrid')

        if(record.MKBSDTermDR != ""){

            //按照第一个诊断模板加载
            /*if(record.MKBSDTermDR.indexOf("And")>0){
                var proId = record.MKBSDTermDR.split("And")[0];
                var termid=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetTermIdByProId",proId);
                var termDesc = ((record.MKBSDStructResult).split('And')[0]).split("[")[0];
            }else{*/
				//var termid=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetTermIdByProId",record.MKBSDTermDR); 
				var termid= record.MKBSDTermDR
				var termDesc = ""
				var desc2 = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","findTermDescById",termid);//取别名 
				//alert(desc2)
				if(desc2 != ""){
					termDesc = desc2
				}else{
					termDesc = (record.MKBSDStructResult).split("[")[0];
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
            var newstr = record.MKBSDStructResult  
            newstr=newstr.replace(reg1,"");
            var reg2=new RegExp("</font>","g"); //创建正则RegExp对象 
            newstr=newstr.replace(reg2,"");
            //$('#SDSViewId').text('结构化结果描述:'+newstr)
            //
            var newstr = record.MKBSDStructResult  */
            SelMRCICDRowid = termid
            //
            //$('.view1').remove();
            //var p1 = '<font color=red class="view1">结构化结果:&nbsp&nbsp'+newstr+'</font>'
            //$('#SDSViewId').append(p1)

        }/*else if(record.MKBSDCenterWord != "" && record.MKBSDTermDR == ""){
            var termDesc = (record.MKBSDCenterWord).split(",")[0];
            var termid = (record.MKBSDCenterWordID).split(",")[0];
            SelMRCICDRowid = termid
            CreatPropertyDom("","",termid,"","");  
            LoadDiagnosData(termDesc,ccc);
            $('#combogrid').combogrid('setValue',termid); 
            //$('.view1').remove();
        }else if(record.MKBSDCenterWord == "" && record.MKBSDTermDR == ""){
            $('#combogrid').combogrid('setValue',''); 
            //$('.view1').remove();
        } */  

    }

    ///知识点按钮
    $("#btnTerm").click(function (e) { 
		var termid=$('#combogrid').combogrid('getValue')
		if(termid==""||termid==undefined){
			$.messager.alert('错误提示','请先选择一条'+sourceDesc+'记录!',"error");
		}else{		
			var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
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
				window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",parentid,menuimg)
			//}else{
			//	parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",menuimg);
		//	}
		}	
	})  


	/**********************************************扩展弹窗开始*********************************************** */ 
	/*$('#result_Extend').click(function(e){
		playExtendDia();
	});
	//窗口展示
	playExtendDia = function(){
		$("#ExtendWin").show();
        var myWin = $HUI.dialog("#ExtendWin",{
            iconCls:'icon-w-edit',
            resizable:true,
            title:'扩展',
            modal:true
        });		
	}
	//扩展表
    var extendcolumns =[[
        {field:'MKBSDRowid',title:'rowid',hidden:true,width:100},
		{field:'MKBSDDesc',title:'诊断短语',sortable:true,width:100},
		{field:'MKBSDResult',title:'诊断表达式',sortable:true,width:100},
        {field:'MKBSDMrc',title:'ICD描述',sortable:true,width:70},
        {field:'MKBSDICD',title:'ICD10代码',sortable:true,width:70}    
    ]];
    var extendGrid = $HUI.datagrid("#extendGrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetExtendList"
        },
        columns: extendcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:10,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
    	//ClassTableName:'User.MKBDocManage',
		//SQLTableName:'MKB_DocManage',
        idField:'MKBSDRowid',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
    	
    });
	$('#extendSearch').click(function(e){
		var diatext=$('#extendDiaText').val();
        $('#extendGrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetExtendList"	,
            'desc': diatext
        });
	})
	$('#extendRefresh').click(function(e){
		$('#extendDiaText').val('');
		$('#extendGrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetExtendList"	
		});
		$('#extendGrid').datagrid('unselectAll');
	})*/
	/**********************************************扩展弹窗结束*********************************************** */
	/***********************************************ICD码修改开始*************************************************** */
	//修改icd编码
	
	var ICDColumns=[[ 
		{field:'MKBTRowid',title:'RowId',width:250,hidden:true}, 
		{field:'MKBDesc',title:'ICD描述',width:290},
		{field:'MKBNumber',title:'ICD10编码',width:290}
		
	]];		
	var icdgrid = $HUI.datagrid("#ICDGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetICDTermList",
			base:icdtermbase
		},
		width:703,
		height:460,
		toolbar:'#ICDbar',
		columns: ICDColumns,  //列信息
		showHeader:false,
		pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:10,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		checkOnSelect:false,
		selectOnCheck:false,
		remoteSort:false,
		idField:'MKBTRowid',
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onDblClickRow:function(rowIndex, field, value){
			ICDRest();
		},
		onClickRow:function(rowIndex,rowData){
			//$("#searchForInter").popover('show');
			var text = (rowData.MKBNumber).slice(0,3);//只要数点前边的数字
			$('#TextInterDesc').val('');
			$('#TextInterCode').val(text);
			$('#interGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
				MethodName:"GetMyList",
				base : icdBase,
				desc : text
			});				
		},
		onLoadSuccess:function(data){
			//setTimeout(function(){
				var record = $('#leftgrid').datagrid('getSelected')
				if(record){
					var icdid = record.MKBSDMDr; 
					if(icdid!="" && icdflagforsel==1 && record.MKBSDICD != 0){
						var index=$('#ICDGrid').datagrid('getRowIndex',icdid);  
						$('#ICDGrid').datagrid('selectRow',index);
					}
				}

			//},4000) 			
		}
	})	
	$('#btnicdsearch').click(function(e){
		icdflagforsel=2
		var desc = $('#TexticdDesc').val()
		var code = $('#TexticdCode').val()
        $('#ICDGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetICDTermList",
			desc:desc,
			number:code,
			base:icdtermbase
		});	
		$('#ICDGrid').datagrid('unselectAll')		
	})
	$('#btnicdrefresh').click(function(e){
		icdflagforsel = 2
		$('#TexticdDesc').val('')
		$('#TexticdCode').val('')
        $('#ICDGrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetICDTermList",
			base:icdtermbase
		});	
		$('#ICDGrid').datagrid('unselectAll')	
	})
	/*$("#btnicdcancel").click(function(e){
		$('#TexticdDesc').val('')
		$('#TexticdCode').val('')
		$('#otherText').val('')
		$("#icdDiv").hide();
		$('#othergrid').datagrid('unselectAll');
		othereditIndex = undefined;
		otherrowsvalue=undefined;		
	})*/

	showICDDiv=function(target,t){
		/*t.css({
			"top": 100,
			"left": 100
		}).show();	*/
		$('#icdDiv').show();	
        var icdDiv = $HUI.dialog("#icdDiv",{
            iconCls:'icon-updatelittle',
            resizable:true,
			title:'修改icd',
			width:$(window).width()*9/10,
			height:$(window).height()*9/10,
            modal:true
		});	
				
	}
	showOtherDiv=function(target,t){
		if(target.offset().top+$("#otherDiv").height()+30>$(window).height()){
			t.css({
				"top": target.offset().top-t.height()-5,
				"left": target.offset().left 
			}).show();
		}
		else{
			t.css({
				"top": target.offset().top+30,
				"left": target.offset().left 
			}).show();
		}		
	}
	//修改icd
	ICDRest = function(){
		var record = $('#leftgrid').datagrid('getSelected');
		if(record){
			var ICDRecord = $('#ICDGrid').datagrid('getSelected');
			if(ICDRecord){
				var MKBICDTermDr = ICDRecord.MKBTRowid;
				var MKBSDMrc = ICDRecord.MKBDesc;
				var MKBSDICD = ICDRecord.MKBNumber;
				var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
				var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",record.Rowid,"",MKBSDICD,MKBSDMrc,"","","");//1
				var data=eval('('+result+')');
				if(data.success=='true'){

					//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",STBBase,record.MKBSDICD,record.Rowid);
					//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",STBBase,ICDRecord.MKBNumber,record.Rowid);											
				}
				$('#leftgrid').datagrid('getRows')[resultIndex].Rowid = data.id;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMDr = MKBICDTermDr;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMrc = MKBSDMrc;
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDICD = MKBSDICD;
				$('#leftgrid').datagrid('refreshRow',resultIndex)
				loadViewTr(record);
				$("#icdDiv").dialog('close');
			}else{
				$.messager.alert('错误提示','请先选择一条ICD!',"error");
				return;	
			}

		}else{
			$.messager.alert('错误提示','请先在左侧列表选择一条数据!',"error");
            return;			
		}		
	}	
	//国际码grid
	var interColumns=[[ 	
		{field:'MKBTRowId',title:'RowId',width:250,hidden:true}, 
		{field:'MKBTDesc',title:'国际码',width:100},
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
			base :icdBase
        });		
	})

	/***********************************************ICD码修改结束******************************************************** */
	/***********************************************别名/其他描述开始********************************************* */
	//var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=OtherUpdate&pEntityName=web.Entity.MKB.MKBMKBStructuredDataOther";
	var DELETE_OTHER_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=DeleteOtherData";	
	var othereditIndex = undefined;
	var otherrowsvalue=undefined;
	var otheroldrowsvalue=undefined;
	var otherpreeditIndex="";	
	var otherColumns=[[ 
		{field:'Rowid',title:'RowId',width:250,hidden:true,editor:'validatebox'}, 
		{field:'MKBSDOther',title:'名称',width:195,editor:'validatebox'},
		{field:'MKBSDOtherNote',title:'备注',width:195,editor:'validatebox'},
		{field:'MKBSDOtherCode',title:'检索码',width:195,editor:'validatebox'},
		{field:'MKBSDOtherMark',title:'标识',width:290,hidden:true}
		
	]];		
	var othergrid= $HUI.datagrid("#othergrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetOtherList",
			id:1,
			mark:'OD'
		},
		width:703,
		height:460,
		columns: otherColumns,  //列信息
		pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:10,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		checkOnSelect:false,
		selectOnCheck:false,
		remoteSort:false,
		idField:'Rowid',
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },	
        onClickRow:function(rowIndex,rowData){
			$('#othergrid').datagrid('selectRow', rowIndex);
			ClickFunO();
		},
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#othergrid').datagrid('getSelected');
			DblClickFun(rowIndex,rowData,field);
	    }      

	})
	//查询
	$('#otherSearch_btn').click(function(e){
		SearchFunLibO();
	})
    SearchFunLibO=function()
    {
		var leftrecord = $('#leftgrid').datagrid('getSelected');
		var desc = $('#otherText').val();
    	$('#othergrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetOtherList",
			id:leftrecord.Rowid,
			mark:pmark,
			desc:desc			
        });
        $('#othergrid').datagrid('unselectAll');
		othereditIndex = undefined;
		otherrowsvalue=undefined;          	
    }	
	//刷新
	$('#otherRefresh_btn').click(function(e){
		ClearFunLibO()
	})
	function ClearFunLibO(){
		var leftrecord = $('#leftgrid').datagrid('getSelected');
		$('#otherText').val('');
        $('#othergrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetOtherList",
			id:leftrecord.Rowid,
			mark:pmark	
        });
		$('#othergrid').datagrid('unselectAll');
		othereditIndex = undefined;
		otherrowsvalue=undefined;
	} 	
	//新增
	$('#otheradd_btn').click(function(e){
		AddDataO();
	})
	//保存
	$('#othersave_btn').click(function(e){
		SaveFunLibO();
	})
	//删除
	$('#otherdel_btn').click(function(e){
		DelDataO();
	})
	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			othereditIndex = undefined;
			otherrowsvalue=undefined;
			otheroldrowsvalue=undefined;
			otherpreeditIndex="";
		})
	});
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
		ClickFunO();
	});	
	//下拉框等组件所在显示列和隐藏列值的互换
	function UpdataRowO(row,Index)
	{
		$('#othergrid').datagrid('updateRow',{
			index: Index,
			row:row
		});
	}
	function endEditingO(){
		if (othereditIndex == undefined){return true}
		if ($('#othergrid').datagrid('validateRow', othereditIndex))
		{
			$('#othergrid').datagrid('endEdit', othereditIndex);
			otherrowsvalue=othergrid.getRows()[othereditIndex];    //临时保存激活的可编辑行的row   
			return true;
		} 
		else
		{
			return false;
		}
	}
	function ClickFunO(type){   //单击执行保存可编辑行
		if (endEditingO()){
			if(otherrowsvalue!= undefined){
				if((otherrowsvalue.MKBSDOther!="")){
					var differentflag="";
					if(otheroldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(otheroldrowsvalue)
						if(oldrowsvaluearr.Rowid==""){
							differentflag=1
						}
						for(var params in otherrowsvalue){
							if(oldrowsvaluearr[params]!=otherrowsvalue[params]){
								differentflag=1
							}
						}
					}
					else{
						differentflag=1
					}
					if(differentflag==1){
						otherpreeditIndex=othereditIndex
						SaveDataO (otherrowsvalue,type);
					}
					else{
						UpdataRowO(otherrowsvalue,othereditIndex)
						othereditIndex=undefined
						otherrowsvalue=undefined
					}
				}
				else{
					$.messager.alert('错误提示','名称不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#othergrid').datagrid('selectRow', othereditIndex)
						.datagrid('beginEdit', othereditIndex);
					AppendDom()
					return 0
				}
			}
		}
	}
	function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）
		if(index==othereditIndex){
			return
		}
		if((row!=undefined)&&(row.Rowid!=undefined)){
			UpdataRowO(row,index)
		}
		otherpreeditIndex=othereditIndex
		if (othereditIndex != index){
			if (endEditingO()){
				$('#othergrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				othereditIndex = index;
			} else {
				$('#othergrid').datagrid('selectRow', othereditIndex);
			}
		}
		otheroldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		AppendDom()
	}
	function AddDataO(){
		otherpreeditIndex=othereditIndex;
		if(ClickFunO('AddDataO')==0){
			return
		}			
		//ClickFunO('AddDataO')
		if (endEditingO()){
			$('#othergrid').datagrid('insertRow',{index:0,row:{}});
			othereditIndex = 0;//$('#othergrid').datagrid('getRows').length-1;
			$('#othergrid').datagrid('selectRow', othereditIndex)
					.datagrid('beginEdit', othereditIndex);
		}
		$('.eaitor-label span').each(function(){	                    
            $(this).unbind('click').click(function(){
                if($(this).prev()._propAttr('checked')){
                    $(target).combobox('unselect',$(this).attr('value'));

                }
                else{
	                $(target).combobox('select',$(this).attr('value'));
	            }
            })
        });
        AppendDom()
	}
	function DelDataO(){
		var record=othergrid.getSelected();
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		//console.log(othergrid.getSelected())
		if((record.Rowid==undefined)||(record.Rowid=="")){
			othergrid.deleteRow(othereditIndex)
			$('#othergrid').datagrid('reload');
			$('#othergrid').datagrid('unselectAll');
			othereditIndex = undefined;
			otherrowsvalue=undefined;
			return;
		}
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.Rowid;
				$.ajax({
					url:DELETE_OTHER_ACTION_URL,
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#othergrid').datagrid('reload');
							$('#othergrid').datagrid('unselectAll');
							othereditIndex = undefined;
							otherrowsvalue=undefined;	
							var resultIndex = $('#leftgrid').datagrid('getRowIndex',$('#leftgrid').datagrid('getSelected'));
							if(otherfield == 'MKBSDOAlias'){
								var tipDesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetOtherDesc",$('#leftgrid').datagrid('getSelected').Rowid,"AN");
								$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDOAlias = tipDesc;
							}else if(otherfield == 'MKBSDOOther'){
								var tipDesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetOtherDesc",$('#leftgrid').datagrid('getSelected').Rowid,"OD");
								$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDOOther = tipDesc;
							}	
							$('#leftgrid').datagrid('refreshRow',resultIndex)  											
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
	function SaveFunLibO(){
		var ed = $('#othergrid').datagrid('getEditors',othereditIndex); 
		if(ed!=""){
			otherpreeditIndex=othereditIndex;
			if (endEditingO()){
				var record=othergrid.getSelected();
				//console.log(record)	  
				//return
				SaveDataO(record);
			}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
	}
	function SaveDataO(record,type){
		if((otherrowsvalue.MKBSDOther=="")){
			$.messager.alert('错误提示','名称不能为空！','error')
			$('.messager-window').click(stopPropagation)
			$('#othergrid').datagrid('selectRow', othereditIndex)
				.datagrid('beginEdit', othereditIndex);
			AppendDom()
			return 0			
		}
		var leftrecord = $('#leftgrid').datagrid('getSelected');
		var data=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","OtherUpdate",leftrecord.Rowid,record.Rowid,record.MKBSDOther,record.MKBSDOtherNote,record.MKBSDOtherCode,pmark);
		var data=eval('('+data+')');
		if(data.success=='true'){   //MKBSDOAlias MKBSDOOther
			var resultIndex = $('#leftgrid').datagrid('getRowIndex',leftrecord);
			if(otherfield == 'MKBSDOAlias'){
				var tipDesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetOtherDesc",leftrecord.Rowid,"AN");
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDOAlias = tipDesc;
			}else if(otherfield == 'MKBSDOOther'){
				var tipDesc=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetOtherDesc",leftrecord.Rowid,"OD");
				$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDOOther = tipDesc;
			}
			$('#leftgrid').datagrid('refreshRow',resultIndex)			
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if(type=='AddDataO'){
				otherpreeditIndex=otherpreeditIndex+1;
			}
			record.Rowid=data.id
			UpdataRowO(record,otherpreeditIndex)
			if(type!='AddDataO'){
				othereditIndex=undefined
				otherrowsvalue=undefined
			}

		}
		else{
			if(type=='AddDataO'){
				
				othergrid.deleteRow(1)
			}
			var errorMsg="修改失败！";
			if(data.errorinfo){
				errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
			}
			$.messager.alert('错误提示',errorMsg,'error',function(){
				UpdataRowO(record,otherpreeditIndex)
				othereditIndex=undefined
				DblClickFun (otherpreeditIndex,record);
			})
			$('.messager-window').click(stopPropagation) 
		}
	}
	$("#otherclose_btn").click(function(e){
		$('#TexticdDesc').val('')
		$('#TexticdCode').val('')
		$('#otherText').val('')
		$("#otherDiv").hide();
		$('#othergrid').datagrid('unselectAll');
		othereditIndex = undefined;
		otherrowsvalue=undefined;		
	})
	//加载表达式、多行文本框等可编辑表格控件
	function AppendDom(){
		if (othereditIndex!=undefined)
		{
			var col=$('#otherlayoutcenter').children().find('tr[datagrid-row-index='+othereditIndex+']')[1];//在不同库里取之不同
			//展示名和拼音码赋值
			var descTarget=$(col).find('td[field=MKBSDOther] input')
			if (othergrid.getRows()[othereditIndex].Rowid==undefined) 
			{
				descTarget.keyup(function(){	
					var desc=descTarget.val()  //中心词列的值		
					//检索码赋值
					var PYCode=Pinyin.GetJPU(desc)
					var PYCodeCol=$("#othergrid").datagrid("getEditor",{index:othereditIndex,field:"MKBSDOtherCode"});							
					$(PYCodeCol.target).val(PYCode)					
				})
			}
			descTarget.click(function(){
				var desc=descTarget.val()  //中心词列的值
				//检索码赋值
				var PYCode=Pinyin.GetJPU(desc)
				var PYCodeCol=$("#othergrid").datagrid("getEditor",{index:othereditIndex,field:"MKBSDOtherCode"});	
				if ((othergrid.getRows()[othereditIndex].Rowid==undefined)||(PYCodeCol.target.val()==""))
				{
					$(PYCodeCol.target).val(PYCode)
				}
				
			})		
			
		}
	} 
	
	/***********************************************别名/其他描述结束********************************************* */
	/***********************************************专业科室功能开始********************************************* */
	//点击专业科室按钮
	$('#pro_loc_btn').click(function(e){
		addIds=""  //要添加的数据
		addDescs=""			
		var records = $('#leftgrid').datagrid('getChecked')
		//var record = $('#leftgrid').datagrid('getSelected')
		if(records!=""){
			//console.log(e.originalEvent.clientX)
			var t = $('#proloc_div')
			t.css({
				"top": 110,
				"left": 550
			}).show();
			/*if(e.originalEvent.clientY+$("#icdDiv").height()+30>$(window).height()){
				t.css({
					"top": e.originalEvent.clientY-t.height()-10,
					"left": e.originalEvent.clientX-300
				}).show();
			}
			else{
				t.css({
					"top": e.originalEvent.clientY+15,
					"left": e.originalEvent.clientX-300
				}).show();
			}*/
			if(records.length==1 && records[0].MKBSDLocs!=""){
				if(records[0].MKBSDStatus=="O"){
					$.messager.alert('错误提示','该记录已审核，数据不能进行任何更改!',"error");
					$('#proloc_div').hide();
					return;	
				}
				var locids = records[0].MKBSDLocs;
				if (locids!="")
				{
					var locarr=locids.split(",");
					for(var i=0;i<locarr.length;i++){
						var node = $('#catTree').tree('find',locarr[i]);
						$('#catTree').tree('check', node.target);
					}
	
				}
			}else if(records.length!=0){
				var overflag=""
				for(var i = 0; i < records.length; i++){
					var record = records[i]
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
					if(resultIndex > -1 && records[i].MKBSDStatus=="O"){
						overflag="Y"
					}
				}
				if(overflag=="Y"){
					$.messager.alert('错误提示','已审核的数据不能更改处理状态，请去掉勾选!',"error");
					$('#proloc_div').hide();
					return;	
				}				
			}else{
				ClearFunLibProLoc()
			}

		}else{
			$.messager.alert('操作提示',"请先在左侧列表勾选至少一条数据！","error");
		}	
	})
	//科室列表
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=GetTreeJson&base="+locbaseID,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate:false,   //是否树展开折叠的动画效果
		id:'id',//这里的id其实是所选行的idField列的值
		onLoadSuccess:function(data){
			$("#FindTreeText").val("")
			$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部

		},
		onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        },
		onContextMenu: function(e, node){
			$('#catTree').tree('select', node.target);
			$('#catTree').tree('check', node.target);
		
		}
			
	});
	//专业科室点击关闭按钮
	$('#locClose_btn').click(function(e){
		ClearFunLibProLoc()
		$('#proloc_div').hide();
		//$('#leftgrid').datagrid('unselectAll');	
		//$("#leftgrid").datagrid('uncheckAll');
	})
	//专业科室重置按钮
	$("#locRefresh_btn").click(function (e) { 
		ClearFunLibProLoc();
	})
	ClearFunLibProLoc = function(){
		$("#FindTreeText").val("")
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#catTree").tree('reload');  // 重新载入当前页面数据reload();
		treeChecked("unchecked", "catTree")
		
	} 
	//专业科室添加按钮
	$("#locSave_btn").click(function (e) { 
		SaveFunLibProLoc();
	}) 
	var addIds=""  //要添加的数据
	var addDescs=""					
	SaveFunLibProLoc = function(){
		addIds=""  //要添加的数据
		addDescs=""			
		var nodes = $('#catTree').tree('getChecked', ['checked','indeterminate']);  //获取选中及不确定的节点
		/*if(nodes.length==0){
			$.messager.alert('错误提示','请至少选择一条科室!',"error");
        	return;		
		}*/	
		//获取要添加到属性内容表的术语
		for (var i = 0; i < nodes.length; i++) {
			if (addIds!=""){
				addIds=addIds+","+nodes[i].id
				addDescs=addDescs+","+nodes[i].text
			}
			else{
				addIds=nodes[i].id
				addDescs=nodes[i].text
			}				
		}
		//var record = $('#leftgrid').datagrid('getSelected')
		var records=$('#leftgrid').datagrid('getChecked')
		if(records!=""){
			for(var i=0;i<records.length;i++){
				//判读是否有重复数据
				var arrlocid=records[i].MKBSDLocs//已有科室id
				var arrlocdesc=records[i].MKBSDLocStr//已有科室描述
				var ids=(records[i].MKBSDLocs).split(",")
				if(records[i].MKBSDLocs!="" && records.length!=1){//给多个数据添加科室

					var carrlocid=","+arrlocid+","
					for(var k=0;k<nodes.length;k++){
						var ido=","+nodes[k].id+","//前后加，用来判断包含关系
						if(carrlocid.indexOf(ido)<0){
							arrlocid=arrlocid+","+nodes[k].id//没有就拼上
							arrlocdesc=arrlocdesc+","+nodes[k].text
						}
					}
					//保存到父表
					var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",records[i].Rowid,"","","","","",arrlocid);		//1			
					/*for (var j = 0; j < nodes.length; j++) {//刷新单元格，更新全文索引
						tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",nodes[j].text,records[i].Rowid+"L");
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					}*/
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[i])
					if(resultIndex > -1){
						//alert("保存"+addIds)
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocs = arrlocid;
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocStr = arrlocdesc;
						$('#leftgrid').datagrid('refreshRow',resultIndex)						
						$('#proloc_div').hide();				
					//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",ICDRecord.MKBSDICD,records[i].Rowid);				
					}						
				}else{
					var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",records[i].Rowid,"","","","","",addIds);//1
					//console.log(result)
					/*for (var j = 0; j < nodes.length; j++) {//刷新单元格，更新全文索引
						tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",nodes[j].text,records[i].Rowid+"L");
					}*/
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					var resultIndex = $('#leftgrid').datagrid('getRowIndex',records[i])
					if(resultIndex > -1){
						//alert("保存"+addIds)
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocs = addIds;
						$('#leftgrid').datagrid('getRows')[resultIndex].MKBSDLocStr = addDescs;
						$('#leftgrid').datagrid('refreshRow',resultIndex)						
						$('#proloc_div').hide();				
					//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",ICDRecord.MKBSDICD,records[i].Rowid);				
					}						
				}
				//tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",ICDRecord.MKBSDICD,ICDRecord.Rowid);											
			}			
		}
		// $("#leftgrid").datagrid('unselectAll');
		// $("#leftgrid").datagrid('uncheckAll');
		// $('#leftgrid').datagrid('clearSelections');
		// $('#leftgrid').datagrid('clearChecked');	
			
	}

	//检索框单击选中输入内容
	$('#FindTreeText').bind('click',function(){
		$('#FindTreeText').select()         
	});
	//查询按钮
	$("#pro_loc_bar").keyup(function(){ 
		var searchStr = $("#FindTreeText").val(); 
		var searchStr =searchStr.toUpperCase();
		//var TextDesc =$.trim($('#FindTreeText').searchbox('getValue')); //检索的描述
		findByRadioCheck("catTree",searchStr,$("input[name='FilterCK']:checked").val())	
	})	
	//术语分类全部、已选、未选
	$HUI.radio("#pro_loc_bar [name='FilterCK']",{
        onChecked:function(e,value){
			var searchStr = $("#FindTreeText").val(); 
			var searchStr =searchStr.toUpperCase();
        	findByRadioCheck("catTree",searchStr,$(e.target).attr("value"))
       }
	});	
	$HUI.checkbox('#checkAllTerms',{
		onChecked:function (e,value) { 
			//var content=document.getElementById("checkAll").innerText; 获取元素内容
			document.getElementById("checkAll").innerHTML="取消全选"; //改变元素内容
			//$("#checkAll").html("全选");
			treeChecked("checked", "catTree")
		},
		onUnchecked:function (e,value) { 
			document.getElementById("checkAll").innerHTML="全选"; //改变元素内容
			treeChecked("unchecked", "catTree")
		}
	})
	//全选反选  
	//参数:selected:checked -全选 ，unchecked-反选 
	//treeMenu:要操作的tree的id；如：id="userTree"  
	function treeChecked(selected, treeMenu) {  
		var roots = $('#' + treeMenu).tree('getChildren');//返回tree的所有根节点数组  
		if (selected=="checked") {  
			for ( var i = 0; i < roots.length; i++) {				
				var node = $('#' + treeMenu).tree('find', roots[i].id);//查找节点  
				$('#' + treeMenu).tree('check', node.target);//将得到的节点选中  
			}  
		} else {  
			for ( var i = 0; i < roots.length; i++) {  
				var node = $('#' + treeMenu).tree('find', roots[i].id);  
				$('#' + treeMenu).tree('uncheck', node.target);  
			}  
		}  
	}		
	/***********************************************专业科室功能结束********************************************* */	
	//下载查询到的数据
	$('#onload_btn').click(function (e){
		DownLoadFile();
	});
	//下载数据导入模板
	$('#loadtem_btn').click(function(e){
		DownLoadImportFile();
	});
	$('#addCheckbox').click(function(e){
		DataImport();
	});

	//导出诊断模板数据	
	$('#loaddiam_btn').click(function(e){
		DownLoadLocFile();	
	});

	//导出实际匹配结果
	$('#onloadresult_btn').click(function(e){
		DownLoadResult();	
	});
	//点击导出诊断模板数据
	function DownLoadLocFile()
	{
		//d file.Write("诊断名,"_"结构化结果,"_"专业科室,"_"处理状态,"_"ICD编码,"_"ICD中文描述,"_"参考中心词,"_"分词,"_"数据类型,"_"别名,"_"其他描述,"_"总频次")
    	$.messager.progress({ 
	       text: '正在下载......',
	       interval: 0
    	 });   //进度条开始
    	
    	
	    var intervalid=setInterval("AddProNum()", 500);//       每500毫秒执行一次	

		$.m({
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            MethodName:"GetYGRHTermGlobalList",
            base:STBBase,
            page:1,
            rows:10000000           
        }, function (jsonData) {
        	var data = eval('(' + jsonData + ')');
        	var arr = []
            arr.push(['频次','别名','中心词','属性','属性内容'])
        	for (var i = 0; i < data.rows.length; i++) {
                arr.push([data.rows[i].Frequnce,data.rows[i].AliasName,data.rows[i].CenterWord,data.rows[i].Proterty ,data.rows[i].PropertyDetail,data.rows[i].DescL1,data.rows[i].DescL2,data.rows[i].DescL3,data.rows[i].DescL4])
            }
            var re=exportExcelForIEAndChorm(arr,"诊断模板数据.xlsx")
            if (re==1)
            {
            	pronumbercount=0
            	var ProgressBar=$.messager.progress("bar")
            	ProgressBar.progressbar("setValue",100)
            	 $.messager.progress('close');//进度条关闭
            }
        }) 


	}
	function DataImport(){
		$('#importWin').show();
        var importWin = $HUI.dialog("#importWin",{
            iconCls:'icon-w-import',
            resizable:true,
            title:'导入知识库模板数据', //'导入数据',
            modal:true,
            buttonAlign : 'center'
        });

	}
	//$('#myWinpro').window('close');
	//点选择按钮时候获取路径
	doChange=function (file){
		var upload_file = $.trim($("#filePath").val());    //获取上传文件
		$('#ExcelImportPath').val(upload_file);     //赋值给自定义input框
	}
    //导入按钮
	$("#ImportData").click(function (e) {
		ImportKBData();
	}); 
	 
	function ImportKBData(){			
		var efilepath=$('#ExcelImportPath').val();  //要导入的模板
		var sheet_id=1;
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
		if(sheet_id=="") {alert ("请填写要导入模板里的第几个sheet！"); return;}
		
		var mkbclassname="web.DHCBL.MKB.MKBStructuredData"  //类名
		try{ 
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
		}		
		catch(e){
			var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
			$.messager.alert('提示',emsg,"error"); 
			return;
		}

		var errorRow="";//没有插入的行
		var errorMsg="";//错误信息
		oWB.worksheets(sheet_id).select(); 
		var oSheet = oWB.ActiveSheet; 
		var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ;
		var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ;
		
		
		var row=2;
		var ProgressText='';
		
		//$('#myWinpro').window('open');
		$('#pro').progressbar({
			text:"正在处理中，请稍后..."
			//value: 0
		});
		alert("开始处理！!");


		for (row>1;row<=rowcount;row++){
			//alert($('#pro').progressbar('getValue'))
			// $('#pro').progressbar('setValue', row/rowcount*100); 
			// $('#pro').attr('text', progressText);	
	
			var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
			var i=row
			for (var j=1;j<=colcount;j++){
				var cellValue=""
				if(typeof(oSheet.Cells(i,j).value)=="undefined"){
					cellValue=""
				}else{
					cellValue=oSheet.Cells(i,j).value
				}
				tempStr+=(cellValue+"[next]")
			}
			//console.log(encodeURI(tempStr))
			var Flag =tkMakeServerCall(mkbclassname,"SaveImportData",tempStr,STBBase);
			
			//alert(mkbclassname+"^"+tempStr+"^"+Flag);
			if (Flag=="true"){
				errorRow=errorRow
				
			}else{
				if(errorRow!=""){
					errorRow=errorRow+","+i
				}else{
					errorRow=i
				}
			}
			tempStr=""
			progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  

			
			if(row==rowcount) //当到达最后一行退出
			{
				if(errorRow!=""){
					errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
				}else{
					errorMsg=oSheet.name+"表导入完成!"
				}
				$('#pro').progressbar('setValue', 100); 
				progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
				$('#pro').attr('text', progressText); 
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
					
				oXL.Quit(); 
				oXL=null;
				oSheet=null;	
				//idTmr = window.setInterval("Cleanup();",1);
				//$('#myWinpro').window('close'); 
			}
			/*else{

			}*/
		}
		//$('#myWinpro').window('close'); 
			
	}
	  
	//下载模板
	function DownLoadImportFile(){
		//诊断名	ICD编码	ICD描述	专业科室	别名	数据来源
		var arr = []
        arr.push(['诊断名','ICD编码','ICD描述','专业科室','别名','数据来源'])
        exportExcelForIEAndChorm(arr,"数据处理工厂导入模板.xlsx")
        /*
		var str = "<tr><td>诊断名</td><td>ICD编码</td><td>ICD描述</td><td>专业科室</td><td>别名</td><td>数据来源</td></tr>";
        document.getElementById("table1").innerHTML = str;
        excel = new ExcelGen({
            "src_id": "table1",
            "show_header": true,
            "fileName":"数据处理工厂导入模板"
        });
        excel.generate();
        */		       
	}
	var pronumbercount=0
	//进度条计数
	AddProNum=function(){
		var ProgressBar=$.messager.progress("bar")
		
		ProgressBar.progressbar("setValue",pronumbercount)
		pronumbercount=pronumbercount+2
		if (pronumbercount==100)
		{
			pronumbercount=98
		}
	}
    //点击下载按钮
    function DownLoadFile()
    {
    	//d file.Write("诊断名,"_"结构化结果,"_"专业科室,"_"处理状态,"_"ICD编码,"_"ICD中文描述,"_"参考中心词,"_"分词,"_"数据类型,"_"别名,"_"其他描述,"_"总频次")
    	$.messager.progress({ 
	       text: '正在下载......',
	       interval: 0
    	 });   //进度条开始
    	
    	
	    var intervalid=setInterval("AddProNum()", 500);//       每500毫秒执行一次	

        $.m({
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            QueryName:"GetDownLoadList",
            page:1,
            rows:10000000           
        }, function (jsonData) {
        	var data = eval('(' + jsonData + ')');
        	
        	var arr = []
            arr.push(['诊断名','结构化结果','专业科室','处理状态','ICD编码','ICD中文描述','参考中心词','分词','数据类型','别名','其他描述','总频次'])
        	for (var i = 0; i < data.rows.length; i++) {
                arr.push([data.rows[i].MKBSDDiag,data.rows[i].ResultStr,data.rows[i].MKBSDLocStr,data.rows[i].Status ,data.rows[i].MKBSDICD,data.rows[i].MKBSDMrc,data.rows[i].MKBSDCenterWord,data.rows[i].MKBSDSegmentation,data.rows[i].Type,data.rows[i].AliasStr,data.rows[i].OtherStr,data.rows[i].SumLoc])
            }
            
            var re=exportExcelForIEAndChorm(arr,"左侧数据.xlsx")
            if (re==1)
            {
            	pronumbercount=0
            	var ProgressBar=$.messager.progress("bar")
            	ProgressBar.progressbar("setValue",100)
            	 $.messager.progress('close');//进度条关闭
            }
            
        }) 
    }

    //点击导出实际匹配结果按钮
    function DownLoadResult()
    {
    	$.messager.progress({ 
	       text: '正在下载......',
	       interval: 0
    	 });   //进度条开始
    	var intervalid=setInterval("AddProNum()", 500);//       每500毫秒执行一次	

    	$.m({
            ClassName:"web.DHCBL.MKB.MKBStructuredData",
            //MethodName:"ExportStructResult",
            QueryName:"GetRealStructResultList",
            DiaSource:STBBase,
            page:1,
            rows:10000000           
        }, function (jsonData) {
        	var data = eval('(' + jsonData + ')');
        	var arr = []
            arr.push(['诊断名','结构化结果','实际匹配结果','是否匹配'])
        	for (var i = 0; i < data.rows.length; i++) {
                arr.push([data.rows[i].MKBConDesc,data.rows[i].SDResult,data.rows[i].RealMatchDia,data.rows[i].Matching ])
            }
            var re=exportExcelForIEAndChorm(arr,"实际匹配结果.xlsx")
            var mm=""
            if (re==1)
            {
            	pronumbercount=0
            	var ProgressBar=$.messager.progress("bar")
            	ProgressBar.progressbar("setValue",100)
            	 $.messager.progress('close');//进度条关闭
            }
           
        }) 
    }
	/************************************************上报审核功能开始******************************************************* */	

	$('#reviewed_data').click(function(e){
		/*var flag = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","JustHosptial",STBBase);
		if(flag != "Y"){
			$.messager.alert('提示','非当前医院!',"error");
			return;
		}*/
		$('#reviewed_Data_Div').show();
		var reviewedDiv = $HUI.dialog("#reviewed_Data_Div",{
            iconCls:'icon-w-paper',
            resizable:true,
			title:'上报待审核数据',
			width:$(window).width()*9/10,
			height:$(window).height()*9/10,
			modal:true

		});	
		//$('#reviewed_grid').datagrid('load')
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
		{field:'MKBDRMRCCode',title:'ICD编码',sortable:true,width:40,
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
					return "<font color=white>未审核</font>"
				}else{
					return "<font color=white>已审核</font>" //green
				}
			},
			styler:function(value,row,index){
				if(value=="N"){
					return 'background-color:#F16E57;'; //FF0033 红 #ee4f38
				}
				else{
					return 'background-color:#2AB66A;'; //33FF66 绿 #4b991b
				}
			}
		},
		{field:'MKBDROtherDesc',title:'其他描述',sortable:true,width:100,hidden:true},
		{field:'MKBDRResonValue',title:'理由id',sortable:true,width:100,hidden:true},
		{field:'MKBDRMRADMDR',title:'admdr',sortable:true,width:100,hidden:true},
		{field:'MKBDRType',title:'admdr',sortable:true,width:100,hidden:true}
		
		]];
		var mygrid = $HUI.datagrid("#reviewed_grid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBDataReviewed",
			QueryName:"GetList",
			type:"SD"
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
			var SDSStr = rowData.MKBDRMRADMDR+"^"+rowData.MKBDRDiagDr+"^"+rowData.MKBDRDiag+"^"+rowData.MKBDRTermDR+"^"+rowData.MKBDRStructResultID+"^"+rowData.MKBDRSupplement+"^"+rowData.MKBDRMRCDr+"^"+rowData.MKBDRMRCCode+"^"+rowData.MKBDRICDDesc+"^"+rowData.MKBDRStructDesc+"^"+rowData.MKBDROtherDesc+"^SD"
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
	//删除上报列表数据
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

	reviewedMethod = function(){
		var record = $('#reviewed_grid').datagrid('getSelected');
		if(record.MKBDRStatus=="N"){
			//修改数据处理工厂数据
			if(record.MKBDRTermDR!=""){
				var childflag=1
			}else{
				var childflag=""
			}
			var flagupdata = ""//判断是否审核成功的标志
			var diadr = record.MKBDRDiagDr
			if(record.MKBDRDiag == "" || record.MKBDRMRCDr == ""){
				$.messager.alert('提示','诊断短语，ICD不能为空!',"error");
				return;
			}			
			if(record.MKBDRDiagDr != ""){//修改
				var PYCode=Pinyin.GetJPU(record.MKBDRDiag);
				var result1=tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","UpdateDiag",record.MKBDRDiagDr,record.MKBDRDiag,"Y",record.MKBDRMRCDr,childflag,PYCode);
				var data1=eval('('+result1+')');
				if(data1.success=='true'){
					flagupdata="Y"
					if(record.MKBDRStructChild.split("||")[1] == ""){
						var SDchild = "" 
					}else{
						var SDchild = record.MKBDRStructChild
					}
					if(record.MKBDRTermDR != ""){
						tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",record.MKBDRDiagDr,SDchild,record.MKBDRStructResultID,"",record.MKBDRTermDR,record.MKBDRSupplement); 
					}
					$.messager.popover({msg: '审核成功!',type:'success',timeout: 1000});
				}else{
					var errorMsg ="审核失败！"
					if (data1.errorinfo) {
						//console.log(data3.errorinfo)
						if((data1.errorinfo).indexOf("键不唯一")){
							$.messager.alert('操作提示',"存在和目标相同的同名诊断！","error");

									
						}else{
							errorMsg =errorMsg+ '<br/>错误信息:' + data3.errorinfo
							$.messager.alert('操作提示',errorMsg,"error");
						}
						
					}
								
		
				}
			}else if(record.MKBDRDiagDr == ""){//新增
				var PYCode=Pinyin.GetJPU(record.MKBDRDiag);
				var result3=tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","SaveNewParDia",record.MKBDRDiag,"Y",PYCode,record.MKBDRMRCDr,record.MKBDRTermDR,record.MKBDRSupplement,record.MKBDRStructResultID); 
				var data3=eval('('+result3+')');
				if(data3.success=='true'){
					flagupdata="Y"
					diadr = data3.id
					$.messager.popover({msg: '审核成功!',type:'success',timeout: 1000});
				}else{
					var errorMsg ="审核失败！"
					if (data3.errorinfo) {
						//console.log(data3.errorinfo)
						if((data3.errorinfo).indexOf("键不唯一")){
							//errorMsg =errorMsg+ '<br/>错误信息:已存在同名的数据！'
							var id = data3.errorinfo.split("&&")[1] 
							diadr = id
							//var PYCode=Pinyin.GetJPU(dia);
							var result4=tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","UpdateDiag",id,record.MKBDRDiag,"Y",record.MKBDRMRCDr,childflag,PYCode);	
							var data4=eval('('+result4+')');
							if(data4.success=='true'){
								flagupdata="Y"
								if(record.MKBDRTermDR != ""){
									tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","SaveData",id,record.MKBDRStructChild,record.MKBDRStructResultID,"",record.MKBDRTermDR,record.MKBDRSupplement); 
								}
								$.messager.popover({msg: '审核成功!',type:'success',timeout: 1000});
							}
									
						}else{
							errorMsg =errorMsg+ '<br/>错误信息:' + data3.errorinfo
							$.messager.alert('操作提示',errorMsg,"error");
						}
						
					}
								
		
				}
			}
			if(flagupdata=="Y"){
				//将状态改为已审核
				var result2 = tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","uptateStatus",record.MKBDRRowId,"Y",diadr);
				var data2=eval('('+result2+')');
				if(data2.success == 'true'){
					var resultIndex = $('#reviewed_grid').datagrid('getRowIndex',record)
					$('#reviewed_grid').datagrid('getRows')[resultIndex].MKBDRStatus = "Y";
					$('#reviewed_grid').datagrid('refreshRow',resultIndex) 	
				}
			}
		}else{
			$.messager.alert('提示','该数据已经审核!',"error");
			return;				
		}

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
			type:"SD"
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
			type:"SD"
		});  
		$('#reviewed_grid').datagrid('unselectAll')   

	})
	/************************************************上报审核功能结束******************************************************* */	
}

$(init);
