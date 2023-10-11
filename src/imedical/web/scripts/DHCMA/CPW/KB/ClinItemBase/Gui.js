//页面Gui
function InitCIBaseWin(){
	var obj = new Object();
	obj.CIBaseID=""
	obj.CICodeStr=""
	obj.CodeStr=""
	obj.HDEmrCodeStr=""
	obj.HDCodeStr=""
    $.parser.parse(); // 解析整个页面 
	$('#winCIBase').dialog({
		title: '诊疗项目库维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		onClose:function(){
			obj.CIBaseID="";
			obj.gridClinItemBase.clearSelections();
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//搜索框
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			obj.gridClinItemBase.load({
				ClassName:"DHCMA.CPW.KBS.ClinItemBaseSrv",
				QueryName:"QryCIBase",
				aKeyValue:value
			});
		}, 
		prompt:'请输入项目描述' 
	});
	//搜索框
	$('#TreeSearch').searchbox({ 
		searcher:function(value,name){
			obj.TreeLoad()
		}, 
		prompt:'请输入病历描述' 
	});
	
	//诊疗项目库
	obj.gridClinItemBase = $HUI.datagrid("#gridClinItemBase",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		url:$URL,
		nowrap:false,
		fitColumns:true,
		idField :'BTID',
		pageSize: 50,
		pageList : [10,20,50,100,200],
		queryParams:{
			ClassName:"DHCMA.CPW.KBS.ClinItemBaseSrv",
			QueryName:"QryCIBase"
		},
		columns:[[
			{field:'BTID',title:'序号',width:'80'},
			{field:'BTDesc',title:'项目描述',width:'300'}, 
			{field:'BTIsActive',title:'是否启用',width:'80'},
			{field:'BTEMRCode',title:'关联病历信息',width:'300'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridClinItemBase_onDbselect(rowData);					
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridClinItemBase_onSelect();	
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});

	obj.TreeLoad = function(){
		var rs = $("#redkw").keywords("getSelected");
		//console.log(obj.CICodeStr)
		$('#treeType').tree({
			lines:true,
			//onlyLeafCheck:true,
			//animate:true,
			checkbox:true,
			cascadeCheck:false,
			url:$URL,
			onBeforeLoad:function(node,param){
			    param.ClassName="DHCMA.CPW.KBS.ClinItemBaseSrv",
				param.QueryName="QryEMRCodeTree",
				param.aCodeStr=obj.CICodeStr,
				param.type=rs[0].id,
				param.aKey=$('#TreeSearch').searchbox('getValue')
				param.ResultSetType = 'array'
				
		    },
			onCheck:function(node){	
			},
			onSelect:function(node){
				var type=""
				if (node.checked) {
					type="0"
				} else {
					type="1"
				}
				if (type!=""){
					var IsCheck = $m({
						ClassName:"DHCMA.CPW.KB.ClinItemBase",
						MethodName:"UpdateEmrCode",
						aID:obj.CIBaseID,
						aCode:node.BTEMRCode,
						aUser:session['DHCMA.USERID'],
						aType:type
					},false);
				}
				if ((IsCheck>0)&&(node.id>0)){
					if(type=="1"){
						$('#treeType').tree('check',node.target);
						$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
						var text="<span style='color:red'>"+node.text+"</span>"
						$('#treeType').tree('update',{
							target:node.target,
							text:"<span style='color:red'>"+node.text+"</span>"
						})
					}else{
						$('#treeType').tree('uncheck',node.target);
						$.messager.popover({msg: '取消成功！',type:'success',timeout: 1000});
						var text=node.text.split(">")[1].split("<")[0]
						$('#treeType').tree('update',{
							target:node.target,
							text:text
						})
					}
					obj.gridClinItemBase.reload() ;//刷新当前页					
					var ret = $m({
						ClassName:"DHCMA.CPW.KB.ClinItemBase",
						MethodName:"GetEmrCodeByID",
						aID:obj.CIBaseID
					},false);
					obj.CICodeStr=ret
					var rowData = $m({
						ClassName:"DHCMA.CPW.KBS.ClinItemBaseSrv",
						MethodName:"GetEmrCode",
						aCode:obj.CICodeStr
					},false);
					if (rowData!=""){
						 obj.CodeStr=rowData.split("^")[0]
						 obj.HDEmrCodeStr=rowData.split("^")[1]
						 obj.HDCodeStr=rowData.split("^")[2]
					}else{
						obj.CodeStr=""
						obj.HDEmrCodeStr=""
						obj.HDCodeStr=""	
					}
					obj.TreeLoad();
				}
			}
			,onBeforeExpand:function(node,param){
			}
			,onExpand:function(node)
			{
				obj.refreshNode(node);			
			}
			,onCollapse:function(node)
			{
				//node.state = "closed";
			},
			onLoadSuccess:function(node,data){		
				for (var i=0;i<data.length;i++){
					$('#treeType').tree('uncheck',data[i].target);
					var par = $('#treeType').tree('getData',data[i].target);
					if (!par) continue
					var parChild = $('#treeType').tree('getRoots',par.target);
					//选中父节点
					if (((obj.CodeStr.indexOf(par.BTEMRCode)>-1) &&(obj.CodeStr!=""))||(par.BTIsActive==1)){
						if(par.id<0)continue;
						$('#treeType').tree('check',data[i].target);
						$('#treeType').tree('update',{
							target:data[i].target,
							text:"<span style='color:red'>"+data[i].text+"</span>"
						})
					}
					//选了子节点需展开
					if ((obj.HDEmrCodeStr.indexOf(par.BTEMRCode)>-1) &&(obj.HDEmrCodeStr!="")){
						obj.refreshNode(data[i])
					}
					//术语集选中
					/*var Newnode = $('#treeType').tree('getNode',data[i].target);
					if ((obj.HDCodeStr.indexOf(Newnode.BTEMRCode)>-1) &&(obj.HDCodeStr!="")){
						$('#treeType').tree('check',data[i].target);
						alert(1)
						//$('#treeType').tree('expandTo',data[i].target);
						$('#treeType').tree('update',{
							target:data[i].target,
							text:"<span style='color:red'>"+data[i].text+"</span>"
						})
					}*/
				}
			}
		});
	}
	obj.refreshNode = function(node){
		if (node.id<0) return
		var rs = $("#redkw").keywords("getSelected");
		//加载子节点数据				
		var subNodes = [];
		$(node.target)
		.next().children().children("div.tree-node").each(function(){   
			var tmp = $('#treeType').tree('getNode',this);
			subNodes.push(tmp);
		});
		for(var i=0;i<subNodes.length;i++)
		{
			$('#treeType').tree('remove',subNodes[i].target);
		}
		$cm({
			ClassName:"DHCMA.CPW.KBS.ClinItemBaseSrv",
			QueryName:"QryEMRCodeTree",
			aEmrCode:node.BTEMRCode,
			aCodeStr:obj.CICodeStr,
			type:rs[0].id,
			ResultSetType:"array", 
			page:1,    
			rows:9999
		},function(rs){   
			$('#treeType').tree('append', {
				parent: node.target,
				data: rs
			});
			//勾选选中的子节点
			for (var i=0;i<rs.length;i++){
				//if(rs[i].id<0)continue;
				if(rs[i].BTIsActive==1){
					var Newnode = $('#treeType').tree('find', rs[i].id);//找到id为”tt“这个树的节点id为”1“的对象
					$('#treeType').tree('check', Newnode.target);//设置选中该节点
					$('#treeType').tree('update',{
						target:Newnode.target,
						text:"<span style='color:red'>"+Newnode.text+"</span>"
					})
				}
			}
			$('.hisui-splitbutton').splitbutton({});                
		});	
	};
    $("#redkw").keywords({
	    singleSelect:true,
	    items:[
	        {text:'全部',id:'1'},
	        {text:'已关联',id:'0'},
	    ],
	    onClick:function(v){
	        obj.TreeLoad();
	    }
	});
    $("#redkw").keywords("select","1");
	InitCIBaseWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


