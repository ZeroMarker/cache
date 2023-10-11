//Create By JDL 20151020 增加一些常用的公共处理方法及函数
//====================================================================
var QueryFlag=true;
var SplitChar="^";
var EVENCOLOR="#DFFFDF";
var oldIndex=-1;
var oldBackColor="";
var	ObjEditFields=new Array();
///modify by lmm 2018-07-30
///描述:打开弹窗界面，且固定尺寸居中显示
///入参:url:界面csp及传参
///    width:弹窗宽度
///    height:弹窗高度
///    left:窗口水平位置
///    top:窗口垂直位置
///返回值：无
function openNewWindow(url,width,height,left,top)
{
	//1100,640,80,0
	if ((width=="")||(width)) width=window.screen.width*0.7;     //弹出窗口的宽度;
	if ((height=="")||(height)) height=window.screen.height*0.7;    //弹出窗口的高度;
	//if ((left=="")||(left)) left=80
	//if ((top=="")||(top)) top=0
  	var top = (window.screen.height-30-height)/2;       //获得窗口的垂直位置;  modify by lmm 2018-08-27
	var left = (window.screen.width-10-width)/2;        //获得窗口的水平位置;  modify by lmm 2018-08-27
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(url,'_blank',',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top);
}

function selectRowColor(grid,row,preIndex)
{
	var index=grid.datagrid('getRowIndex',row);
	if (preIndex==index) return;
	oldIndex=index;
	
	var panel =grid.datagrid('getPanel');   
    var tr = panel.find('div.datagrid-body tr');
    var bakcss="";
    tr.each(function(){
	    var tempIndex = parseInt($(this).attr("datagrid-row-index"));
	    if ((tempIndex%2)==1)
	    {
	        if (tempIndex == index)
	        {
		        oldBackColor=($(this).css("background-color"));
		        $(this).css({   
		            "background": "#0092DC",
		            "color": "#fff"  
		        });	
	        }
	        if (tempIndex == preIndex)
	        {
		        $(this).css("background-color",oldBackColor);
		        $(this).css("color","#000000");
		    }
	    }
     });
     oldcss=bakcss;
}


///Add By ZX 2017-03-08
///描述:改变日期控件格式为YYYY-MM
///EasyUI处有用到，HISUI暂时未用到，？移动位置到EasyUI.common.js中
/*jQuery.extend({
    MonthBox: function(Obj) {
    Obj.datebox({    
        onShowPanel : function() {// 显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层    
            span.trigger('click'); // 触发click事件弹出月份层    
            if (!tds)    
                setTimeout(function() {// 延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔    
                    tds = p.find('div.calendar-menu-month-inner td');    
                    tds.click(function(e) {    
                        e.stopPropagation(); // 禁止冒泡执行easyui给月份绑定的事件    
                        var year = /\d{4}/.exec(span.html())[0]// 得到年份   
                        , month = parseInt(jQuery(this).attr('abbr'), 10) ; // 月份 
                        Obj.datebox('hidePanel') // 隐藏日期对象    
                        .datebox('setValue', year + '-' +  month); // 设置日期的值    
                    });
                }, 0);
        },
        parser : function(s) {// 配置parser，返回选择的日期
            if (!s)
                return new Date(); 
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);    
        },    
        formatter : function(d) { 
            var month = d.getMonth()+1;
            if(month<10){
                month = "0"+month;
            }     
            return d.getFullYear() + '-' + month;    
            
        }// 配置formatter，只返回年月    
    });
    var p = Obj.datebox('panel'), // 日期选择对象    
    tds = false, // 日期选择对象中月份    
    span = p.find('span.calendar-text'); // 显示月份层的触发控件  
    }
});*/
/// HISUI用EASYUI方式改写不可用,重新处理
function MonthBox(monthID){
	$("#"+monthID).datebox({    
        onShowPanel : function() {// 显示日期选择对象后再触发弹出月份层的事件，初始化时没有生成月份层    
            span.trigger('click'); // 触发click事件弹出月份层 
            if (!tds)    
                setTimeout(function() {// 延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔   
                    tds = p.find('div.calendar-menu-month-inner td'); 
                    tds.click(function(e) {
                        e.stopPropagation(); // 禁止冒泡执行easyui给月份绑定的事件    
                        var year = /\d{4}/.exec(span.html())[0]// 得到年份   
                        , month = parseInt(jQuery(this).attr('abbr'), 10) ; // 月份 
                        $("#"+monthID).datebox('hidePanel') // 隐藏日期对象    
                        .datebox('setValue', year + '-' +  month); // 设置日期的值    
                    });
                }, 0);
        },
        parser : function(s) {// 配置parser，返回选择的日期
            if (!s)
                return new Date(); 
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);    
        },    
        formatter : function(d) { 
            var month = d.getMonth()+1;
            if(month<10){
                month = "0"+month;
            }     
            return d.getFullYear() + '-' + month;    
            
        }// 配置formatter，只返回年月    
    });
    var p = $("#"+monthID).datebox('panel'), // 日期选择对象    
    tds = false, // 日期选择对象中月份    
    //span = p.find('span.calendar-text'); // 显示月份层的触发控件
    span = p.find('div.calendar-ttitle span');
}

///add by zy 2017-08-07 ZY0162
///easyUI formatter  checkbox 格式化
///入参：
///		value	：判断Y/N
///		functionName	:处理逻辑函数
///		para	：事件的参数
///		index	：行索引
///返回 html代码
///modify by lmm 2020-03-06 begin LMM0062 增加入参 disable：灰化
function checkBox(value,functionName,para,index,disable)
{
	html='<input type="checkbox" '+disable+' name="DataGridCheckbox" onclick="'+functionName+'(&quot;'+para+'&quot;,&quot;'+index+'&quot;)"';
	if(value=="Y"){html=html+' checked="checked" value="N" >';}
	else{html=html+' value="Y" >';}	
	return html
}



//modify by lmm 2018-02-01
//图标隐藏方法
//入参说明：
// 		ComponentName:	组件名
// 		val:	对应元素值为空则隐藏该图标
// 		Item:	图标所在的元素名
function hiddenTableIcon(ComponentName,val,Item)
{    
	if ((ComponentName=="")||(val=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
	
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
		var panel = $("#"+ComponentName).datagrid("getPanel");
		var index=i
		var obj = panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+val+"] div");
		if (obj.html()=="")
		{
			//$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().html("")  //modify by jyp 2018-08-27
			//$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().hide()  //modified by czf 20180902 解决html("")无法隐藏CheckBox的问题
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().css("visibility", "hidden");	//Mozy	941331	2019-8-1	修正元素隐藏后表格布局发生异常
		}
    }
}
//add by lmm 2018-02-02
//设置前台页面记录显示背景色
//入参说明：
//		vComponentTableName:组件名  
function setBackgroundColor(vComponentTableName)
{
	var Objtbl = $("#"+vComponentTableName).datagrid("getRows"); //这段代码是获取当前页的所有数据行。
  	var Rows=Objtbl.length  //获取当前页数据的行数
	if(Rows==1) return
	
	for (var i=0;i<Rows;i++)
	{
		if (Objtbl[i].TBackgroundColor!="")
		{
			var index=i;  
			$("td .datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"]").css({"background-color":Objtbl[i].TBackgroundColor})

		}
	}
}

/**********************************************************************************************************/
/**********************************************************************************************************/
/**********************************************************************************************************/

///Add By DJ 2018-07-30
///描述:常用按钮初始化
///入参:无
///返回值:无
/// Modify by zx 2020-04-01 BUG ZX0082 按钮描述统一处理
function initButton()
{
	if (jQuery("#BSave").length>0)
	{
		jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BSave").on("click", BSave_Clicked);
		jQuery("#BSave").linkbutton({text:'保存'});
	}
	if (jQuery("#BSubmit").length>0)
	{
		jQuery("#BSubmit").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BSubmit").on("click", BSubmit_Clicked);
		jQuery("#BSubmit").linkbutton({text:'提交'});
	}
	if (jQuery("#BDelete").length>0)
	{
		jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
		jQuery("#BDelete").on("click", BDelete_Clicked);
		jQuery("#BDelete").linkbutton({text:'删除'});
	}
	if (jQuery("#BAudit").length>0)
	{
		jQuery("#BAudit").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BAudit").on("click", BAudit_Clicked);
	}
	if (jQuery("#BPrint").length>0)
	{
		jQuery("#BPrint").linkbutton({iconCls: 'icon-w-print'});
		jQuery("#BPrint").on("click", BPrint_Clicked);
		jQuery("#BPrint").linkbutton({text:'打印'});
	}
	if (jQuery("#BFind").length>0)
	{
		jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
		jQuery("#BFind").on("click", BFind_Clicked);
		jQuery("#BFind").linkbutton({text:'查询'});
	}
	if (jQuery("#BPicture").length>0)
	{
		jQuery("#BPicture").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BPicture").on("click", BPicture_Clicked);
	}
	if (jQuery("#BEquipInfo").length>0)
	{
		jQuery("#BEquipInfo").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BEquipInfo").on("click", BEquipInfo_Click);
	}
	if (jQuery("#BMaintDetail").length>0)
	{
		jQuery("#BMaintDetail").linkbutton({iconCls: 'icon-upload'});
		jQuery("#BMaintDetail").on("click", BMaintDetail_Click);
	}
	if (jQuery("#BEvaluate").length>0)
	{
		jQuery("#BEvaluate").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BEvaluate").on("click", BEvaluate_Clicked);
	}
	///add by zy 20181109 增加作废按钮 ZY0178
	if (jQuery("#BCancel").length>0)
	{
		jQuery("#BCancel").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BCancel").on("click", BCancel_Clicked);
		jQuery("#BCancel").linkbutton({text:'作废'});
	}
	///add by QW20191205 增加关闭按钮 需求号:1123791
	if (jQuery("#BClosed").length>0)
	{
		jQuery("#BClosed").linkbutton({iconCls: 'icon-w-close'});
		jQuery("#BClosed").on("click", BClosed_Clicked);
		jQuery("#BClosed").linkbutton({text:'关闭'});
	}
	///End by QW20191205 增加关闭按钮 需求号:1123791
	//add by csj 20191127 增加清屏按钮
	if (jQuery("#BClear").length>0)
	{
		jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});	//czf 2666600
		jQuery("#BClear").on("click", BClear_Clicked);
		jQuery("#BClear").linkbutton({text:'清屏'});
	}
	//add by ZY250  20200104 增加预折旧
	if (jQuery("#BDepre").length>0)
	{
		jQuery("#BDepre").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BDepre").on("click", BDepre_Clicked);
		jQuery("#BDepre").linkbutton({text:'(预)计提折旧'});
	}
	///add by ZY0298 20220307 增加手工折旧月结快照按钮事件定义
	if (jQuery("#BHandWork").length>0)
	{
		jQuery("#BHandWork").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BHandWork").on("click", BHandWork_Clicked);
		jQuery("#BHandWork").linkbutton({text:'手工折旧月结'});
	}
	//add by czf 2022-08-23
	if (jQuery("#BAdd").length>0)
	{
		jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
		jQuery("#BAdd").on("click", BAdd_Clicked);
		jQuery("#BAdd").linkbutton({text:'新增'});
	}
	
	initButtonColor();		//设置极简积极按钮颜色 czf 2023-01-10
}

///Add By DJ 2018-07-06
///描述:隐藏元素
///入参:vElementID 元素名
///		vValue 隐藏显示值 true或1表示隐藏,其它显示
///返回值:无
function hiddenObj(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if ((vValue==true)||(vValue==1))
		{
			jQuery("#"+vElementID).hide()
		}
		else
		{
			jQuery("#"+vElementID).show()
		}
	}
}
///Add By DJ 2018-07-06
///描述:动态生成审批流用户自定义操作窗口
///入参:vWin	动态Div窗口名
///		vDataGridID 动态DataGrid数据窗
///		vParams  DataGrid调用后台的Json格式串{ClassName:类名,QueryName:查询名,Arg1:参数值1,....Argn:参数值n,ArgCnt:参数总数}
///		vcolumns DataGrid显示内容。格式[[列1,列2,...列n]] 
///				 列格式{field:查询输出列,title:前台显示列名,width:列宽,align:显示位置,hidden:是否隐藏}
///		vType   业务操作类型 0审核 1取消审核
///返回值:无
function initApproveFlowGrid(vWin,vDataGridID,vParams,vcolumns,vType)
{
	jQuery("#"+vDataGridID).datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:vParams,
		singleSelect:true,
		fit:true,
		columns:vcolumns,
	    onSelect: function (rowIndex, rowData) {
		    //执行选择操作
		    dataGridSelect(vType,rowData);
		    //关闭当前窗口
		    jQuery("#"+vWin).window('close');
		}
	});
}
///Add By DJ 2018-07-06
///描述:获取当前功能的编辑字段信息
///入参:objtbl	当前页面对象,
///		currow	列表元素中的行号
///返回值:表信息1@表信息2...@表信息n
///		  表信息中记录格式为：表名&记录1&记录2...&记录n
///		  记录信息中记录格式为：ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
function approveEditFieldsInfo(objtbl,currow)
{
	var cellName="";
	var cellValue="";
	var editCellName="";
	var cols=ObjEditFields.length;
	if (cols==0)  return ""
	
	var tableNames=new Array();
	var tableInfos=new Array();
	var newRowFlags=new Array();
	var tableCount=0;
	
	var RowID=getElementValue("RowID");	
	var rows=0;
	if (objtbl)
	{
		var RowData=objtbl.datagrid("getRows");		//modified by czf 20180116
		rows=RowData.length-1	//modified by csj 20190809
	}
	//rows=objtbl.rows.length-1;
	if ((currow)&&(currow!=""))
	{
		rows=currow
	}
	else
	{
		currow=0
		//rows=0	//modified by csj 20190809	
	}
	//i从0开始,保证没有列表也能照常执行
	for (var i=currow;i<=rows;i++)
	{
		//初始化新行标志
		for (var k=0;k<tableCount;k++)
		{
			newRowFlags[k]=1;
		}		
		
		//var TRowID=getElementValue("TRowIDz"+i)	//modified by czf 20180116
		var TRowID=""
		if (objtbl) TRowID=RowData[i].TRowID	//modified by czf 20180116
		for (var j=0;j<cols;j++)
		{
			cellName=ObjEditFields[j].FieldName;
			editCellName=ObjEditFields[j].EditFieldName;
			if (ObjEditFields[j].ListFlag=="Y")
			{
				//对于列表元素,如果没有TRowID则不处理
				if ((TRowID=="-1")||(TRowID=="")) continue;
				//cellName=cellName+"z"+i;	
				//editCellName=editCellName+"z"+i;
			}
			else
			{
				//对于非列表字段只执行一次
				if (i!=0) continue;				
			}
			
			///查找对应的tableNames			
			var tableIndex=-1;
			for (var k=0;k<tableCount;k++)
			{
				if (tableNames[k]==ObjEditFields[j].TableName) tableIndex=k;
			}
			//如果在tableNames数组中尚未有该表信息,则建立该信息
			if (tableIndex==-1)
			{
				tableNames[tableCount]=ObjEditFields[j].TableName;
				tableInfos[tableCount]=ObjEditFields[j].TableName;
				newRowFlags[tableCount]=0;
				tableIndex=tableCount;
				tableCount=tableCount+1;				
				if (ObjEditFields[j].ListFlag!="Y")	//非列表元素
				{
					//modified by csj 20191012 优先取配置的RowIDName(建议配置),否则取界面上定义的RowID（getElementValue("RowID")---新规范界面需定义）
					if (ObjEditFields[j].RowIDName!="")
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+getElementValue(ObjEditFields[j].RowIDName);
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+RowID;
					}					
				}
				else	//列表元素	
				{
					//modified by csj 20191012 优先取配置的RowIDName(必须配置),否则取列表TRowID（RowData[i].TRowID---新规范基本取不到）
					if (ObjEditFields[j].RowIDName!="")		
					{
						//tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+getElementValue(ObjEditFields[j].RowIDName+"z"+i);
						var RowIDName=ObjEditFields[j].RowIDName;
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+RowData[i][RowIDName]
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+TRowID;
					}
				}
			}
			else
			{
				//如果为新行,则需要记录TRowID
				if (newRowFlags[tableIndex]==1)
				{
					//modified by csj 20191012 优先取配置的RowIDName(必须配置),否则取列表TRowID（RowData[i].TRowID---新规范基本取不到）
					if (ObjEditFields[j].RowIDName!="")
					{
						//tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+getElementValue(ObjEditFields[j].RowIDName+"z"+i);
						var RowIDName=ObjEditFields[j].RowIDName;
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+RowData[i][RowIDName]	
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+TRowID;
					}
					newRowFlags[tableIndex]=0;
				}
			}
			if (ObjEditFields[j].FieldType==6)
			{
				if(ObjEditFields[j].ListFlag!="Y")
				{
					cellValue= getElementValue(cellName);
				}
				else
				{
					cellValue=RowData[i][cellName]
				}
			}
			else
			{
				if(ObjEditFields[j].ListFlag!="Y")
				{
					cellValue= trim(getElementValue(cellName));
				}
				else
				{
					cellValue=RowData[i][cellName]
				}
			}
			if ((ObjEditFields[j].MustFlag=="Y")&&(cellValue==""))
			{
				if (ObjEditFields[j].FieldCaption=="")
				{
					messageShow("","","",t[ObjEditFields[j].FieldName]+t[-9201]);
				}
				else
				{
					messageShow("","","",ObjEditFields[j].FieldCaption+t[-9201]);
				}
				setFocus(editCellName);
				return "-1";
			}
			tableInfos[tableIndex]=tableInfos[tableIndex]+"^"+cellValue+","+ObjEditFields[j].RowID;
		}
	}
	
	var EditFieldsInfo="";
	for (var k=0;k<tableCount;k++)
	{
		if (EditFieldsInfo!="") EditFieldsInfo=EditFieldsInfo+"@";
		EditFieldsInfo=EditFieldsInfo+tableInfos[k];
	}
	return EditFieldsInfo
}
///Add By DJ 2018-07-30
///描述:元素获取焦点
///入参:id 获取焦点的元素名
///返回值:无
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}
///Add By DJ 2018-07-30
///描述:生成星号评价界面
///入参:vElementID 元素名
///		vStarType 星号图标类型, 默认大图标 0大图标 1小图标
///		vNumber	 显示星号数量，默认5星
///		vhalf	是否支持半星操作,默认支持 true, false
///		vscore	星号分值
///		vhints	星号图标提示信息,数组格式
///		vReadOnly 是否只读 ture表示只读 false表示可以操作
///返回值:无
function fStarEvaluate(vElementID, vStarType, vNumber, vhalf, vscore, vhints, vReadOnly)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if ((vStarType==0)||(vStarType=="")||(vStarType==undefined))
		{
			var starHalf="star-half-big.png"
			var starOff="star-off-big.png"
			var starOn="star-on-big.png"
		}
		else
		{
			var starHalf="star-half.png"
			var starOff="star-off.png"
			var starOn="star-on.png"
		}
		if ((vNumber=="")||(vNumber==undefined)) vNumber=5
		if ((vhalf=="")||(vhalf==undefined)) vhalf=true
		if ((vReadOnly=="")||(vReadOnly==undefined)) vReadOnly=false
		if ((vscore=="")||(vscore==undefined)) vscore=0.1
		if ((vhints=="")||(vhints==undefined)) vhints=["1星","2星","3星","4星","5星"]
		jQuery("#"+vElementID).raty({
	        path     : "../scripts/dhceq/raty/images",
	        half     : vhalf,
	        size     : 24,
	        round	 :{down:.26},
	        number	 : vNumber,
	        readOnly : vReadOnly,
	        starHalf : starHalf,
	        starOff  : starOff,
	        starOn   : starOn,
	        score	 : vscore,
	        hints	 : vhints,
	        click	 : function(score, evt) {jQuery("#"+vElementID+"Score").text(score+"分");}
	      })
	}
}

///add by lmm 2018-09-20
///描述：hisui改造：获取日期值
///入参：vElementID 日期控件id
function GetJQueryDate(vElementID)
{
	var DateText=jQuery(vElementID).datebox('getText');
	var DateValue=jQuery(vElementID).datebox('getValue');
	if ((DateText=="")&&(DateValue!="")) return ""
	return DateValue
}
