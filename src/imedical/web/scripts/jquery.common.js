//Create By JDL 20151020 ����һЩ���õĹ���������������
//====================================================================
var QueryFlag=true;
var SplitChar="^";
var EVENCOLOR="#DFFFDF";
var oldIndex=-1;
var oldBackColor="";
var	ObjEditFields=new Array();
///modify by lmm 2018-07-30
///����:�򿪵������棬�ҹ̶��ߴ������ʾ
///���:url:����csp������
///    width:�������
///    height:�����߶�
///    left:����ˮƽλ��
///    top:���ڴ�ֱλ��
///����ֵ����
function openNewWindow(url,width,height,left,top)
{
	//1100,640,80,0
	if ((width=="")||(width)) width=window.screen.width*0.7;     //�������ڵĿ��;
	if ((height=="")||(height)) height=window.screen.height*0.7;    //�������ڵĸ߶�;
	//if ((left=="")||(left)) left=80
	//if ((top=="")||(top)) top=0
  	var top = (window.screen.height-30-height)/2;       //��ô��ڵĴ�ֱλ��;  modify by lmm 2018-08-27
	var left = (window.screen.width-10-width)/2;        //��ô��ڵ�ˮƽλ��;  modify by lmm 2018-08-27
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
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
///����:�ı����ڿؼ���ʽΪYYYY-MM
///EasyUI�����õ���HISUI��ʱδ�õ������ƶ�λ�õ�EasyUI.common.js��
/*jQuery.extend({
    MonthBox: function(Obj) {
    Obj.datebox({    
        onShowPanel : function() {// ��ʾ����ѡ�������ٴ��������·ݲ���¼�����ʼ��ʱû�������·ݲ�    
            span.trigger('click'); // ����click�¼������·ݲ�    
            if (!tds)    
                setTimeout(function() {// ��ʱ������ȡ�·ݶ�����Ϊ������¼������Ͷ���������ʱ����    
                    tds = p.find('div.calendar-menu-month-inner td');    
                    tds.click(function(e) {    
                        e.stopPropagation(); // ��ֹð��ִ��easyui���·ݰ󶨵��¼�    
                        var year = /\d{4}/.exec(span.html())[0]// �õ����   
                        , month = parseInt(jQuery(this).attr('abbr'), 10) ; // �·� 
                        Obj.datebox('hidePanel') // �������ڶ���    
                        .datebox('setValue', year + '-' +  month); // �������ڵ�ֵ    
                    });
                }, 0);
        },
        parser : function(s) {// ����parser������ѡ�������
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
            
        }// ����formatter��ֻ��������    
    });
    var p = Obj.datebox('panel'), // ����ѡ�����    
    tds = false, // ����ѡ��������·�    
    span = p.find('span.calendar-text'); // ��ʾ�·ݲ�Ĵ����ؼ�  
    }
});*/
/// HISUI��EASYUI��ʽ��д������,���´���
function MonthBox(monthID){
	$("#"+monthID).datebox({    
        onShowPanel : function() {// ��ʾ����ѡ�������ٴ��������·ݲ���¼�����ʼ��ʱû�������·ݲ�    
            span.trigger('click'); // ����click�¼������·ݲ� 
            if (!tds)    
                setTimeout(function() {// ��ʱ������ȡ�·ݶ�����Ϊ������¼������Ͷ���������ʱ����   
                    tds = p.find('div.calendar-menu-month-inner td'); 
                    tds.click(function(e) {
                        e.stopPropagation(); // ��ֹð��ִ��easyui���·ݰ󶨵��¼�    
                        var year = /\d{4}/.exec(span.html())[0]// �õ����   
                        , month = parseInt(jQuery(this).attr('abbr'), 10) ; // �·� 
                        $("#"+monthID).datebox('hidePanel') // �������ڶ���    
                        .datebox('setValue', year + '-' +  month); // �������ڵ�ֵ    
                    });
                }, 0);
        },
        parser : function(s) {// ����parser������ѡ�������
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
            
        }// ����formatter��ֻ��������    
    });
    var p = $("#"+monthID).datebox('panel'), // ����ѡ�����    
    tds = false, // ����ѡ��������·�    
    //span = p.find('span.calendar-text'); // ��ʾ�·ݲ�Ĵ����ؼ�
    span = p.find('div.calendar-ttitle span');
}

///add by zy 2017-08-07 ZY0162
///easyUI formatter  checkbox ��ʽ��
///��Σ�
///		value	���ж�Y/N
///		functionName	:�����߼�����
///		para	���¼��Ĳ���
///		index	��������
///���� html����
///modify by lmm 2020-03-06 begin LMM0062 ������� disable���һ�
function checkBox(value,functionName,para,index,disable)
{
	html='<input type="checkbox" '+disable+' name="DataGridCheckbox" onclick="'+functionName+'(&quot;'+para+'&quot;,&quot;'+index+'&quot;)"';
	if(value=="Y"){html=html+' checked="checked" value="N" >';}
	else{html=html+' value="Y" >';}	
	return html
}



//modify by lmm 2018-02-01
//ͼ�����ط���
//���˵����
// 		ComponentName:	�����
// 		val:	��ӦԪ��ֵΪ�������ظ�ͼ��
// 		Item:	ͼ�����ڵ�Ԫ����
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
			//$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().hide()  //modified by czf 20180902 ���html("")�޷�����CheckBox������
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().css("visibility", "hidden");	//Mozy	941331	2019-8-1	����Ԫ�����غ��񲼾ַ����쳣
		}
    }
}
//add by lmm 2018-02-02
//����ǰ̨ҳ���¼��ʾ����ɫ
//���˵����
//		vComponentTableName:�����  
function setBackgroundColor(vComponentTableName)
{
	var Objtbl = $("#"+vComponentTableName).datagrid("getRows"); //��δ����ǻ�ȡ��ǰҳ�����������С�
  	var Rows=Objtbl.length  //��ȡ��ǰҳ���ݵ�����
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
///����:���ð�ť��ʼ��
///���:��
///����ֵ:��
/// Modify by zx 2020-04-01 BUG ZX0082 ��ť����ͳһ����
function initButton()
{
	if (jQuery("#BSave").length>0)
	{
		jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BSave").on("click", BSave_Clicked);
		jQuery("#BSave").linkbutton({text:'����'});
	}
	if (jQuery("#BSubmit").length>0)
	{
		jQuery("#BSubmit").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BSubmit").on("click", BSubmit_Clicked);
		jQuery("#BSubmit").linkbutton({text:'�ύ'});
	}
	if (jQuery("#BDelete").length>0)
	{
		jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
		jQuery("#BDelete").on("click", BDelete_Clicked);
		jQuery("#BDelete").linkbutton({text:'ɾ��'});
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
		jQuery("#BPrint").linkbutton({text:'��ӡ'});
	}
	if (jQuery("#BFind").length>0)
	{
		jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
		jQuery("#BFind").on("click", BFind_Clicked);
		jQuery("#BFind").linkbutton({text:'��ѯ'});
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
	///add by zy 20181109 �������ϰ�ť ZY0178
	if (jQuery("#BCancel").length>0)
	{
		jQuery("#BCancel").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BCancel").on("click", BCancel_Clicked);
		jQuery("#BCancel").linkbutton({text:'����'});
	}
	///add by QW20191205 ���ӹرհ�ť �����:1123791
	if (jQuery("#BClosed").length>0)
	{
		jQuery("#BClosed").linkbutton({iconCls: 'icon-w-close'});
		jQuery("#BClosed").on("click", BClosed_Clicked);
		jQuery("#BClosed").linkbutton({text:'�ر�'});
	}
	///End by QW20191205 ���ӹرհ�ť �����:1123791
	//add by csj 20191127 ����������ť
	if (jQuery("#BClear").length>0)
	{
		jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});	//czf 2666600
		jQuery("#BClear").on("click", BClear_Clicked);
		jQuery("#BClear").linkbutton({text:'����'});
	}
	//add by ZY250  20200104 ����Ԥ�۾�
	if (jQuery("#BDepre").length>0)
	{
		jQuery("#BDepre").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BDepre").on("click", BDepre_Clicked);
		jQuery("#BDepre").linkbutton({text:'(Ԥ)�����۾�'});
	}
	///add by ZY0298 20220307 �����ֹ��۾��½���հ�ť�¼�����
	if (jQuery("#BHandWork").length>0)
	{
		jQuery("#BHandWork").linkbutton({iconCls: 'icon-w-submit'});
		jQuery("#BHandWork").on("click", BHandWork_Clicked);
		jQuery("#BHandWork").linkbutton({text:'�ֹ��۾��½�'});
	}
	//add by czf 2022-08-23
	if (jQuery("#BAdd").length>0)
	{
		jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
		jQuery("#BAdd").on("click", BAdd_Clicked);
		jQuery("#BAdd").linkbutton({text:'����'});
	}
	
	initButtonColor();		//���ü��������ť��ɫ czf 2023-01-10
}

///Add By DJ 2018-07-06
///����:����Ԫ��
///���:vElementID Ԫ����
///		vValue ������ʾֵ true��1��ʾ����,������ʾ
///����ֵ:��
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
///����:��̬�����������û��Զ����������
///���:vWin	��̬Div������
///		vDataGridID ��̬DataGrid���ݴ�
///		vParams  DataGrid���ú�̨��Json��ʽ��{ClassName:����,QueryName:��ѯ��,Arg1:����ֵ1,....Argn:����ֵn,ArgCnt:��������}
///		vcolumns DataGrid��ʾ���ݡ���ʽ[[��1,��2,...��n]] 
///				 �и�ʽ{field:��ѯ�����,title:ǰ̨��ʾ����,width:�п�,align:��ʾλ��,hidden:�Ƿ�����}
///		vType   ҵ��������� 0��� 1ȡ�����
///����ֵ:��
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
		    //ִ��ѡ�����
		    dataGridSelect(vType,rowData);
		    //�رյ�ǰ����
		    jQuery("#"+vWin).window('close');
		}
	});
}
///Add By DJ 2018-07-06
///����:��ȡ��ǰ���ܵı༭�ֶ���Ϣ
///���:objtbl	��ǰҳ�����,
///		currow	�б�Ԫ���е��к�
///����ֵ:����Ϣ1@����Ϣ2...@����Ϣn
///		  ����Ϣ�м�¼��ʽΪ������&��¼1&��¼2...&��¼n
///		  ��¼��Ϣ�м�¼��ʽΪ��ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
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
	//i��0��ʼ,��֤û���б�Ҳ���ճ�ִ��
	for (var i=currow;i<=rows;i++)
	{
		//��ʼ�����б�־
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
				//�����б�Ԫ��,���û��TRowID�򲻴���
				if ((TRowID=="-1")||(TRowID=="")) continue;
				//cellName=cellName+"z"+i;	
				//editCellName=editCellName+"z"+i;
			}
			else
			{
				//���ڷ��б��ֶ�ִֻ��һ��
				if (i!=0) continue;				
			}
			
			///���Ҷ�Ӧ��tableNames			
			var tableIndex=-1;
			for (var k=0;k<tableCount;k++)
			{
				if (tableNames[k]==ObjEditFields[j].TableName) tableIndex=k;
			}
			//�����tableNames��������δ�иñ���Ϣ,��������Ϣ
			if (tableIndex==-1)
			{
				tableNames[tableCount]=ObjEditFields[j].TableName;
				tableInfos[tableCount]=ObjEditFields[j].TableName;
				newRowFlags[tableCount]=0;
				tableIndex=tableCount;
				tableCount=tableCount+1;				
				if (ObjEditFields[j].ListFlag!="Y")	//���б�Ԫ��
				{
					//modified by csj 20191012 ����ȡ���õ�RowIDName(��������),����ȡ�����϶����RowID��getElementValue("RowID")---�¹淶�����趨�壩
					if (ObjEditFields[j].RowIDName!="")
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+getElementValue(ObjEditFields[j].RowIDName);
					}
					else
					{
						tableInfos[tableIndex]=tableInfos[tableIndex]+"&"+RowID;
					}					
				}
				else	//�б�Ԫ��	
				{
					//modified by csj 20191012 ����ȡ���õ�RowIDName(��������),����ȡ�б�TRowID��RowData[i].TRowID---�¹淶����ȡ������
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
				//���Ϊ����,����Ҫ��¼TRowID
				if (newRowFlags[tableIndex]==1)
				{
					//modified by csj 20191012 ����ȡ���õ�RowIDName(��������),����ȡ�б�TRowID��RowData[i].TRowID---�¹淶����ȡ������
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
///����:Ԫ�ػ�ȡ����
///���:id ��ȡ�����Ԫ����
///����ֵ:��
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}
///Add By DJ 2018-07-30
///����:�����Ǻ����۽���
///���:vElementID Ԫ����
///		vStarType �Ǻ�ͼ������, Ĭ�ϴ�ͼ�� 0��ͼ�� 1Сͼ��
///		vNumber	 ��ʾ�Ǻ�������Ĭ��5��
///		vhalf	�Ƿ�֧�ְ��ǲ���,Ĭ��֧�� true, false
///		vscore	�Ǻŷ�ֵ
///		vhints	�Ǻ�ͼ����ʾ��Ϣ,�����ʽ
///		vReadOnly �Ƿ�ֻ�� ture��ʾֻ�� false��ʾ���Բ���
///����ֵ:��
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
		if ((vhints=="")||(vhints==undefined)) vhints=["1��","2��","3��","4��","5��"]
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
	        click	 : function(score, evt) {jQuery("#"+vElementID+"Score").text(score+"��");}
	      })
	}
}

///add by lmm 2018-09-20
///������hisui���죺��ȡ����ֵ
///��Σ�vElementID ���ڿؼ�id
function GetJQueryDate(vElementID)
{
	var DateText=jQuery(vElementID).datebox('getText');
	var DateValue=jQuery(vElementID).datebox('getValue');
	if ((DateText=="")&&(DateValue!="")) return ""
	return DateValue
}
