/*
Creator:DingYanan
CreatDate:2018-09-05
Description:知识库编辑器-给药途径
*/
//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Freq");
var DELETE_ACTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseFreq&pClassMethod=DeleteData";

var init = function(){
	var editIndex = undefined;
	var rowsvalue=undefined;
	var oldrowsvalue=undefined;
	var preeditIndex="";
	var columns =[[  
	  {field:'PHEFDescF',title:'描述多选框F',width:200,hidden:true,editor:'validatebox'},
	  {field:'PHEFDesc',title:'描述',width:200,sortable:true,editor:{
		  	type:'combobox',
		  	options:{
				url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtFreq&QueryName=GetDataForCmb1&ResultSetType=array",
				rowStyle:"checkbox",
				multiple:true,
				panelHeight: 200,
				valueField:'PHEFRowId',
				textField:'PHEFDesc',
				onHidePanel:function(){
		            var opts = $(this).combobox('options');
		        	var val=$(this).combobox('getText');
		        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PHEFDescF'});
					$(ed.target).val(val)
		        }
			}
		}},
	  {field:'PHINSTModeF',title:'级别下拉框F',width:100,hidden:true,editor:'validatebox'},
	  {field:'PHINSTMode',title:'级别',width:100,sortable:true,formatter:function(value){
		  if(value=='W'){ return "警示"; }
		  else if(value=='C') { return "管控";}
		  else if(value=='S') { return "统计";}
		  else{return "";}
		},editor:{
		  	type:'combobox',
			options:{
				panelHeight: 200,
				valueField:'id',
				textField:'text',
				data:[
					{id:'W',text:'警示'},
					{id:'C',text:'管控'},
					{id:'S',text:'统计'}			
				],
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PHINSTModeF'});
					$(ed.target).val(val)
		        }	
				
			}
		}},
	  {field:'PDAAgeDrF',title:'年龄下拉框F',width:150,hidden:true,editor:'validatebox'},
	  {field:'PDAAgeDr',title:'年龄',width:150,sortable:true,editor:{
		  	type:'combobox',
			options:{
				valueField:'PDARowID',
				textField:'PDAAgeDesc',
				panelHeight: 200,
				url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmb1&ResultSetType=array" ,
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAAgeDrF'});
					$(ed.target).val(val)
		        },
		        onSelect:function(record){
					var rowid=record.PDARowID
					$.ajax({
						url:AGE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",   
						dataType:"TEXT",  
						success: function(data){
								var data=eval('('+data+')'); 
								var PDAAgeMin=data.PDAAgeMin;
								var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAMinVal'});
								$(ed.target).val(PDAAgeMin)
								
								var PDAAgeMax=data.PDAAgeMax;
								var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAMaxVal'});
								$(ed.target).val(PDAAgeMax)
								
								var UomDesc=data.UomDesc;
								var PDAUomDr=data.PDAUomDr;
								var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAUomDr'});
								$(ed.target).combobox('setValue', PDAUomDr);	
								
								var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAUomDrF'});
								$(ed.target).val(UomDesc)
								
						}  
					})		
				}
						
			}
		}},
	  {field:'PDAMinVal',title:'年龄最小值',width:100,sortable:true,editor:'validatebox'},
	  {field:'PDAMaxVal',title:'年龄最大值',width:100,sortable:true,editor:'validatebox'},
	  {field:'PDAUomDrF',title:'年龄单位下拉框F',width:100,hidden:true,editor:'validatebox'},
	  {field:'PDAUomDr',title:'年龄单位',width:100,sortable:true,editor:{
		  	type:'combobox',
			options:{
				valueField:'PHEURowId',
				textField:'PHEUDesc',
				panelHeight: 200,
				url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmbYMD&ResultSetType=array" ,
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDAUomDrF'});
					$(ed.target).val(val)
		        }	
				
			}
		}},
	  {field:'PDFExcludeFlagF',title:'禁忌下拉框F',width:100,hidden:true,editor:'validatebox'},
	  {field:'PDFExcludeFlag',title:'禁忌',width:100,sortable:true,align:'center',formatter:ReturnFlagIcon,editor:{
		  	type:'combobox',
			options:{
				panelHeight: 200,
				valueField:'id',
				textField:'text',
				data:[
					{id:'Y',text:'是'},
					{id:'S',text:'否'}			
				],
	            onHidePanel:function(){
		        	var val=$(this).combobox('getText');
		        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PDFExcludeFlagF'});
					$(ed.target).val(val)
		        }	
				
			}
		}},
	  {field:'PDFAlertMsg',title:'提示消息',width:200,
		  	formatter:function(value,row,index){
			  	return '<span class="mytooltip" title="'+value+'">'+value+'</span>'
			},
		  	editor:{type:'textarea'}
		  },
	  {field:'PDFRowId',title:'PDFRowId',width:80,sortable:true,hidden:true,editor:'validatebox'},
	  {field:'PDFInstDr',title:'PDFInstDr',width:80,sortable:true,hidden:true,editor:'validatebox'},
	  {field:'PDFFreqDR',title:'PDFFreqDR',width:80,sortable:true,hidden:true,editor:'validatebox'}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDiseaseFreq",         ///调用Query时
			QueryName:"GetListNew",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		//ClassTableName:'User.BDPTableList',
		//SQLTableName:'BDP_TableList',
		scrollbarSize :0,
		idField:'PDFInstDr',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			},
		onDblClickRow:function(rowIndex,rowData){
			//$('.mytooltip').tooltip('hide');
			//DblClickFun(rowIndex,rowData)
        },
        onClickRow:function(rowIndex,rowData){
			$('#mygrid').datagrid('selectRow', rowIndex);
			ClickFun()
	    },
        onLoadSuccess:function(data){
	        $('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true
				    })
				}
		    })

        },
        onDblClickCell:function(rowIndex, field, value){
	        var rowData=$('#mygrid').datagrid('getSelected');
	        $('.mytooltip').tooltip('hide');
			DblClickFun(rowIndex,rowData,field)
	    }
	});
	$('#add_btn').click(function (e){
       AddData();

    });
    $('#update_btn').click(function (e){
        SaveFunLib();
    });
    $('#del_btn').click(function (e){
        DelData();
    });
	$('#btnRefresh').click(function(){
		ClearFunLib()
	});
	$("#DescSearch").searchbox({
        searcher:function(value,name){
        	SearchFunLib()
        }
	})
	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	})
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun()
	});
	function AppendDom(field){
		var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']')[1];
		//20200427 谷雪萍 修改
        /*$(col).find('table').each(function(){
			var target=$(this).find('input:first')
			if(target.css('display')=='none'){
				target.next().find('input:first').click(function(){
					
				})
			}
			else{
				target.click(function(){
					
				})
			}
		})*/
		CellDisplay(col,field) 
		ShowTADom(col,"PDFAlertMsg")
	}  
	function CellDisplay(jq1,jq2){
		if(jq2==undefined){return}
		if(jq2.indexOf('Msg')>=0){
			var target=$(jq1).find('td[field='+jq2+'] textarea')
		}
		else{
			var target=$(jq1).find('td[field='+jq2+'] input')
		}
		var typeclass=target.attr("class");
		if(typeclass.indexOf('combo')>=0){
			setTimeout(function(){
				$(target[0]).combo('showPanel')
			},200)
			
		}
		else if(typeclass.indexOf('validatebox')>=0){
			target.focus()
		}
		else{
			target.focus()
			CreateTADom(target)
		}
	}
	//下拉框等组件所在显示列和隐藏列值的互换
	function UpdataRow(row,Index){
		var temp;
		temp=row.PHEFDesc
		row.PHEFDesc=row.PHEFDescF
		row.PHEFDescF=temp
		
		temp=row.PHINSTMode
		row.PHINSTMode=row.PHINSTModeF
		row.PHINSTModeF=temp  
		
		temp=row.PDAAgeDr
		row.PDAAgeDr=row.PDAAgeDrF
		row.PDAAgeDrF=temp
		
		temp=row.PDAUomDr
		row.PDAUomDr=row.PDAUomDrF
		row.PDAUomDrF=temp
		
		temp=row.PDFExcludeFlag
		row.PDFExcludeFlag=row.PDFExcludeFlagF
		row.PDFExcludeFlagF=temp
		
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
		$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true
				    })
				}
		    })
	}
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#mygrid').datagrid('validateRow', editIndex)){
			$('#mygrid').datagrid('endEdit', editIndex);
			rowsvalue=mygrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	function ClickFun(type){   //单击执行保存可编辑行
		if (endEditing()){
			if(rowsvalue!= undefined){
				if(rowsvalue.PHEFDesc!=""){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						for(var params in rowsvalue){
							if(oldrowsvaluearr[params]==undefined){oldrowsvaluearr[params]=""}
							if(rowsvalue[params]==undefined){rowsvalue[params]=""}
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
					$.messager.alert('错误提示','描述不能为空！','error')
					$('.messager-window').click(stopPropagation)
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
					return
				}
			}

		}
	}
	function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）
		
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.PDFRowId!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#mygrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#mygrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		AppendDom(field)
	}
	//添加
	function AddData(){
		//2020-05-06 谷雪萍 修改BUG：点击新增，维护描述后，点击空白处，然后点击新增，描述被清空
		var ed = $('#mygrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			$.messager.alert('警告','请先执行保存操作！','warning');
			return;
		}
		preeditIndex=editIndex;
		//ClickFun('AddData')
		if(ClickFun('AddData')==0){
			return
		}			
		if (endEditing()){
			$('#mygrid').datagrid('insertRow',{index:0,row:{}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#mygrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
			var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'PHINSTMode'});
								$(ed.target).combobox('setValue', mode);	
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
	function DelData(){
		var record=mygrid.getSelected();
		if(!record){
			$.messager.alert('提示','请选择一条记录！','error');
			return;
		}
		
		if((record.PDFRowId==undefined)||(record.PDFRowId=="")){
			mygrid.deleteRow(editIndex)
			editIndex = undefined;
			rowsvalue=undefined;
			return;
		}
		
		$.messager.confirm('确认','您要删除这条数据吗?',function(r){
			if(r){
				id=record.PDFRowId;
				$.ajax({
					url:DELETE_ACTION_URL,
					data:{"id":id},
					type:'POST',
					success:function(data){
						var data=eval('('+data+')');
						if(data.success=='true'){
							$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							$('#mygrid').datagrid('reload');
							$('#mygrid').datagrid('unselectAll');
							editIndex = undefined;
							rowsvalue=undefined;
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
	
	function SaveFunLib (){
		var ed = $('#mygrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			preeditIndex=editIndex;
			if (endEditing()){
				var record=mygrid.getSelected();	
				SaveData(record);
				
			}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
	}
	function SaveData (record,type){
		var Mode= record.PHINSTMode;	 //管制级别
		var Type="FREQ";//知识库目录
		var OrderNum=0;//顺序
		var Lib="DRUG";//知识库标识
		var ActiveFlag="Y";//是否可用
		var SysFlag="Y";//是否系统标识
		
		var ExcludeFlag=record.PDFExcludeFlag
		if (ExcludeFlag!="Y")
		{
			ExcludeFlag="N"
		}
		else
		{
			ExcludeFlag="true"
		}
		
		var Age = record.PDAAgeDr      		
		var MinVal=$.trim(record.PDAMinVal);
		var MaxVal=$.trim(record.PDAMaxVal);
		var UomDr = record.PDAUomDr ;	
		var AlertMsg=$.trim(record.PDFAlertMsg);
		var InstDr=$.trim(record.PDFInstDr);
	
		if ((MinVal!="")&&(MaxVal!=""))
		{
			if (parseInt(MinVal)>parseInt(MaxVal)) {
				$.messager.alert('错误提示','年龄最小值不能大于年龄最大值!',"error");
				$('.messager-window').click(stopPropagation)
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
				return;
			}
		}
		
		//获取选中的数据
		var PDFFreqDRs=record.PHEFDesc
		var rows = PDFFreqDRs.split(",");;	
	
		var repeatstr=""
		var flagRet=""
		var freqStr = "";
		for(var i=0; i<rows.length; i++){
			if(freqStr!="") freqStr = freqStr+"*";
			var PDFFreqDR=rows[i]; //频率id
			freqStr = freqStr+PDFFreqDR+"^"+Mode+"^"+Type+"^"+OrderNum+"^"+GenDr+"^"+PointerDr+"^"+PointerType+"^"+Lib+"^"+ActiveFlag+"^"+SysFlag+"^"+ExcludeFlag+"^"+Age+"^"+MinVal+"^"+MaxVal+"^"+UomDr+"^"+AlertMsg+"^"+InstDr;
			var repeatstr=repeatstr+"<"+PDFFreqDR+"&"+Age+">"
		}
		
		//遍历已选列表，判断是否有重复数据
		var centerrows = $('#mygrid').datagrid('getRows');	
		for(var j=0; j<centerrows.length; j++){	
			if ((centerrows[j].PDFRowId!="")&&(centerrows[j].PDFRowId!=record.PDFRowId)){
				var FreqDR=centerrows[j].PDFFreqDR; //频率id
				var AgeDr=centerrows[j].PDAAgeDrF; //年龄id
				var str="<"+FreqDR+"&"+AgeDr+">"
				
				if (repeatstr.indexOf(str)>-1){
					flagRet = 1;
					break;
				}
			}
		}
	
		if (flagRet==1)
		{
			$.messager.alert('错误提示','该记录已存在!',"error");
			$('.messager-window').click(stopPropagation)
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
			return;
		}
		
		if (InstDr!=""){
			var saveURL="UpdateData"
		}
		else
		{
			var saveURL="SaveData"
		}
		
		var data = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseFreq", saveURL,freqStr)  
		var data=eval('('+data+')');
        if(data.success=='true'){		        
		    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			
		    if(type=='AddData'){
		        preeditIndex=preeditIndex+1;
		    }
		    record.PDFRowId=data.id
			//UpdataRow(record,preeditIndex)
		    ClearFunLib()
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
		
	function SearchFunLib(){
		var desc=$.trim($('#DescSearch').searchbox('getValue')); //检索的描述
		$('#mygrid').datagrid('load',{
			ClassName:"web.DHCBL.KB.DHCPHDiseaseFreq",
			QueryName:"GetListNew",
			'desc': desc,
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		});
		$('#mygrid').datagrid('unselectAll');
	}
	function ClearFunLib(){
		//$("#TextCode").val("");
		$("#DescSearch").searchbox('setValue','')
		//var type=$HUI.combobox('#TextType').setValue();
		$('#mygrid').datagrid('load',{
			ClassName:"web.DHCBL.KB.DHCPHDiseaseFreq",
			QueryName:"GetListNew",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		});
		$('#mygrid').datagrid('unselectAll');
		editIndex = undefined;
		rowsvalue=undefined;
	}
	function CreateTADom(target){
			$('body').append('<textarea rows="10" cols="30" id="textareadom" style="z-index:999999;display:none;position:absolute;background:#FFFFFF">')
			$("#textareadom").val(target.val())
			if(target.offset().top+$("#textareadom").height()>$(window).height()){
				$("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top-$("#textareadom").height()+27,
                    "width":target.width()
                }).show();
			}
			else{
				$("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top,
                    "width":target.width()
                }).show();
			}
            $("#textareadom").focus(function(){
	        	
	        }).focus().blur(function(){
                target.val($("#textareadom").val())	
				$(this).remove();
			}).keydown(function(e){
					if(e.keyCode==13){
						//$("#textareadom").hide();
						target.val($("#textareadom").val())	
					}
			}).click(stopPropagation);
		}
	function ShowTADom(jq1,jq2){   //生成textarea下拉区域
		
		var target=$(jq1).find('td[field='+jq2+'] textarea')
		target.click(function(){
			CreateTADom(target)
		});
		
	}
	
};
$(init);
