var t=new Array();
///Add By DJ 2018-07-06
///����:HISUIҳ������Ԫ��֮�������LookupԪ�س�ʼ��
///���:vExcludesids ��ʼ������Ԫ�� ��ʽ"Ԫ����1,Ԫ����2,....Ԫ����n"
///����ֵ:��
tabflag=0   //add by lmm 2020-06-29 �س���һ�����ȫ�ֱ���
function initLookUp(vExcludesids)
{
	var lookupid={};
	var lookupparas={};
	var lookupjsfun={};
	//������ʽ�����ɸ�дԪ��
	$(".hisui-validatebox").each(function(){
		var id=$(this)[0].id;
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			//ȡԪ�ص���Ϣ
			var options=jQuery("#"+id).attr("data-options");
			if ((options!=undefined)&&(options!=""))
			{
				//תjson��ʽ
				options='{'+options+'}';
				var options=eval('('+options+')');
				var componentName=options.component;
				if ((componentName!=undefined)&&(componentName!=""))
				{
					//modify by lmm 2020-02-28 �����������Զ�������С����
					var vminQueryLen="0"
					//modify by lmm 2020-06-17 ���ӷŴ󾵵����ߴ�
					singlelookup(id,componentName,options.paras,options.jsfunction,vminQueryLen,options.defaultsize)
				}
			}
		}
	});
}
///Add By DJ 2018-07-30
///����:HISUI����LookupԪ�س�ʼ��
///���:vElementID lookupԪ����
///		vComponentName	lookupԪ������Ϣ��������
///		vQueryParams lookupԪ�ص��ò�ѯ���. �����ȼ��ߵͷ�Ϊ�������(1)JS����(2)data-options��������(3)δ����ȡ����Ϣ��������
///					data-options�������ø�ʽ:"paras:json��ʽ��������"
///					������ʽ:[{name:�����1,type:��������,value:����ֵ},{name:�����2,type:����ֵ����,value:����ֵ}....]
///					����ֵ���ͷ�Ϊ:1 ��ʾlookup�����Ԫ��,2 ��ʾ�̶�ֵ,3  session����,4 ָ��Ԫ����
///		vfunction lookupԪ��ѡ���¼�ص�����.�����ȼ��ߵͷ�Ϊ�������(1)JS����(2)data-options��������(3)δ���ù̶����ú���setSelectValue
///					data-options�������ø�ʽ:"jsfunction:�ص�������"
///����ֵ:��
///������� vminQueryLen���������Զ�������С���� modify by lmm 2020-02-28 LMM0060
///modify by lmm 2020-06-17 vDefaultSize�����ӷŴ󾵵����ߴ�
function singlelookup(vElementID,vComponentName,vQueryParams,vfunction,vminQueryLen,vDefaultSize)
{
	if (vComponentName!="")
	{
		var lookupinfo=tkMakeServerCall("web.DHCEQ.Plat.CTCComponentSet","GetComponentsInfo",vComponentName)
		var lookupObj=JSON.parse(lookupinfo)
		var componentInfo=lookupObj[vComponentName]
		if (componentInfo!="")
		{
			var options=jQuery("#"+vElementID).attr("data-options");
			var optionflag=0
			if ((options!=undefined)&&(options!=""))
			{
				//תjson��ʽ
				optionflag=1
				options='{'+options+'}';
				var options=eval('('+options+')');
			}
			if (((vQueryParams=="")||(vQueryParams==undefined))&&(optionflag==1)){vQueryParams=options.paras}
			if (((vfunction=="")||(vfunction==undefined))&&(optionflag==1)){vfunction=options.jsfunction}
			if (((vDefaultSize=="")||(vDefaultSize==undefined))&&(optionflag==1)){vDefaultSize=options.defaultsize}
			lookupHander(new component(componentInfo,vDefaultSize),vElementID,vQueryParams,vfunction,vminQueryLen);
		}
	}
}
///Add By DJ 2018-07-30
///����:��������Ϣ�����ַ��������ж���
///���:����Ϣ�����ַ���.��ʽ:"����Ϣ����RowID^����Ϣ������^����Ϣ�������^��������^���ò�ѯ��^���ò�ѯ���^lookupԪ��DR����^lookupԪ����ʾ����^�ص�����"
///		���ò�ѯ��θ�ʽ:"����1#����2#......����n"		������ʽ:"�����*���λ��*���ֵ����*���ֵ"
///����ֵ:��
//modify by lmm 2020-06-17 LookupSize�����ӷŴ󾵵����ߴ�
function component(str,LookupSize)
{
	var str=str.split("^");
	this.id=str[0];
	this.name=str[1];
	this.caption=str[2];
	this.className=str[3];
	this.queryName=str[4];
	this.params=str[5];
	this.idField=str[6];
	this.textField=str[7];
	//modified by ZY0197 2019-11-27  
	//this.callBackFunction=str[8];
	this.width=400;
	this.height=200;
	if (str[8]!="")
	{
		var defaultSize=str[8]
	}
	if((LookupSize!="")&&(LookupSize!=undefined))
	{
		var defaultSize=LookupSize
	}
	if ((defaultSize!="")&&(defaultSize!=undefined))
	{
		var defaultSize=defaultSize.split(",");
		for (var i=0;i<defaultSize.length;i++)   
		{
			var oneCaption=defaultSize[i].split(":");
			if (oneCaption[0]=="width") this.width=oneCaption[1];
			else if (oneCaption[0]=="height") this.height=oneCaption[1];
		}
	}
	this.columns=getCurColumnsInfo(this.name,"","","");
}
///Add By DJ 2018-07-06
///����:HISUI����ҳ��Ŵ�Ԫ��Lookup���弰change��ն�ӦdrԪ��ֵ�¼���
///���:component ����Ϣ�������
///		vElementID lookupԪ����
///		vQueryParams lookupԪ�ص��ò�ѯ���. ��Ϊ�������(1)JS����(2)data-options��������(3)δ����ȡ����Ϣ��������
///					data-options�������ø�ʽ:"paras:json��ʽ��������"
///					������ʽ:[{name:�����1,type:��������,value:����ֵ},{name:�����2,type:����ֵ����,value:����ֵ}....]
///					����ֵ���ͷ�Ϊ:1 ��ʾlookup�����Ԫ��,2 ��ʾ�̶�ֵ,3  session����,4 ָ��Ԫ����
///		vfunction lookupԪ��ѡ���¼�ص�����.��Ϊ�������(1)JS����(2)data-options��������(3)δ���ù̶����ú���setSelectValue
///					data-options�������ø�ʽ:"jsfunction:�ص�������"
///����ֵ:��
///������� vminQueryLen���������Զ�������С���� modify by lmm 2020-02-28 LMM0060
function lookupHander(component,vElementID,vQueryParams,vfunction,vminQueryLen)
{
	if ((vminQueryLen=="")||(vminQueryLen==undefined))
	{
		
		var vminQueryLen="0"
	}
    if (component=="") return
    $('#'+vElementID).lookup({
		//modified by ZY0197 2019-11-27
		panelWidth:component.width,
		panelHeight:component.height,
		mode: 'remote',
		pagination:true,
		lazy:true,
		showPageList:false,
		showRefresh:false,
		minQueryLen:vminQueryLen,   //modify by lmm 2020-02-24
		isCombo:true,
	    onBeforeLoad:function(param){
			//JS�ļ����ݲ�����dataoption���Զ������
			if ((vQueryParams!="")&&(vQueryParams!=undefined))
			{
				for (var i=0;i<vQueryParams.length;i++)
				{
				    //��ȡcombogrid�����ֵ
				    if(vQueryParams[i].type=="1") {param[vQueryParams[i].name]=$('#'+vQueryParams[i].value).lookup("getText");}
					//��ȡĬ��ֵ  ����
					else if(vQueryParams[i].type=="2"){param[vQueryParams[i].name]=vQueryParams[i].value;}
					//��ȡsessionֵ
					else if(vQueryParams[i].type=="3"){param[vQueryParams[i].name]=session[vQueryParams[i].value];}
					//ͨ��jsдgetParam����ȡֵ
					else if(vQueryParams[i].type=="5"){param[vQueryParams[i].name]=getParam(vQueryParams[i].value);}
					//��ȡCheckBoxֵ	 MZY0030	1340074		2020-06-01
					else if(vQueryParams[i].type=="6"){param[vQueryParams[i].name]=document.getElementById(vQueryParams[i].value).checked;}
					//��ȡ��������Ԫ��ֵ
					else{param[vQueryParams[i].name]=getElementValue(vQueryParams[i].value);}
				}
			}
			else
			{
				var option=component.params.split("#");
			    for (var i=0;i<option.length;i++)
			    {
				    var oneParaInfo=option[i].split("*");
				    //��ȡcombogrid�����ֵ
				    if(oneParaInfo[2]=="1") {param[oneParaInfo[0]]=$('#'+vElementID).lookup("getText");}
					//��ȡĬ��ֵ  ����
					else if(oneParaInfo[2]=="2"){param[oneParaInfo[0]]=oneParaInfo[3];}
					//��ȡsessionֵ
					else if(oneParaInfo[2]=="3"){param[oneParaInfo[0]]=session[oneParaInfo[3]];}
					//ͨ��jsдgetParam����ȡֵ
					else if(oneParaInfo[2]=="5"){param[oneParaInfo[0]]=getParam(oneParaInfo[0]);}
					//��ȡ��������Ԫ��ֵ
					else{param[oneParaInfo[0]]=getElementValue(oneParaInfo[3]);}
				}
			}
			return true;
			},
		queryParams:{ClassName: component.className,QueryName: component.queryName},
		url: $URL,
		idField: component.idField,
		textField: component.textField,
		onSelect:function (ind,item){
			if ((vfunction)&&(vfunction!=undefined)&&(vfunction!=""))
			{
				//JS�ļ����ݻص�������dataoption���Զ���ص�����
				vfunction(item);
			}
			else
			{
				setSelectValue(vElementID,item);

			}
				lookuptab(vElementID)   //add by lmm 2020-06-29 �س���һ�����
				tabflag=1
			},
		columns:component.columns
	});
	$('#'+vElementID).bind("input propertychange change",function(event){clearData(vElementID)})
}

///Add By DJ 2018-07-30
///����:����lookupԪ������Ϣ��������̬���ɶ�Ӧչʾcolumns����
///��Σ�
///		componentName:  lookupԪ������Ϣ������
///		groupID	: ��ȫ��ID
///		userID	���û�ID
///		hospID	��hospIDԺ��ID
///     frozen	: �����б�ʶ   /// Modefiedy by ZC0041 2018-10-29
///����ֵ:lookupԪ������Ϣ�����Ӧչʾ�ж���.  ��ʽ��[[��1,��2....,��n]]
///		�и�ʽ:{field:��ѯ�����,title:ǰ̨��ʾ����,width:�п�,align:��ʾλ��,hidden:�Ƿ�����}
function getCurColumnsInfo(componentName,groupID,userID,hospID,frozen)
{
	if(frozen==null) frozen=""
    var columns = new Array();
    var cols = new Array();
    var resultData=$.cm({
		ClassName:"web.DHCEQ.Plat.CTCComponentSet",
		QueryName:"ComponentSetItem",
		ComponentName:componentName,
		GroupID:groupID,
		UserID:userID,
		HosptailID:hospID,
		Frozen:frozen,     /// Modefiedy by ZC0041 2018-10-29 ��Ӷ����б�ʶ
		},false)
    	///modified by zy 20180930  ZY0170  ����ͬһSort����Ĳ����д���
	var preSort=-1;
	var newColData;	
	var multipCol = new Array();
	for (var i=0;i<resultData.rows.length;i++)
	{
		var colData=resultData.rows[i];
		var curSort=colData.TSort;
		var insertFlag=""						//add by wl 2019-10-25
		if ((curSort==preSort)&&(curSort!=0))  //modify by lmm 2018-12-13
		{
			//newColData.title="����"
			multipCol.push(colData);
			insertFlag=1					   //add by wl 2019-10-25
		}
		else
		{
			preSort=curSort;
		}
		var nextsort=""
		if (i<resultData.rows.length)
		{
			if (resultData.rows[i+1]) nextsort=resultData.rows[i+1].TSort
		}
		if ((nextsort!=curSort)||(nextsort==0))  //modify by lmm 2018-12-13
		{
			if (multipCol.length==0) multipCol.push(colData);
			newColData=new setColData(colData,multipCol);
			cols.push(newColData);
			multipCol=[]
		}
		else
		{
			
			if (insertFlag=="") multipCol.push(colData);   //modify by wl 2019-10-25
		}
	}
	columns.push(cols);
	return columns;
}
///Add By DJ 2018-07-30
///����:��������Ϣ�����ֶ����ݴ������ֶζ���
///���:oneItem ����Ϣ�������
///����ֵ:��
///modify by jyp 2018-10-19  JYP0015 ����ȡ��Style��ѭ��ȡֵ��
function setColData(oneItem,multipCol)
{
	if (oneItem=="") return "";
    this.field = oneItem.TName;
    this.title = oneItem.TCaption;
    this.description=oneItem.TDescription;
    //Modify By zx 2020-02-20 BUG ZX0076 ������
    this.sortable=oneItem.TOrderMode;
    //modified by ZY0199 2019-12-11  
    //0:string,1:int,2:float,3:date,4:time,5:bool
    if ((oneItem.TDataType=="1")||(oneItem.TDataType=="2"))this.align ="right" ;
	if (oneItem.THidden=="Y")this.hidden =true ;
	else this.hidden=false
	///modified by zy 20191202 ZY0197
	///����DataType��DisplayType  �����ֶε�����.
	///DataType���ڼ�¼Ԫ�ص��ֶ�����
	///DisplayTyp���ڿ���Ԫ����ʾ�����ݺͱ༭״̬�µ�����
	///setEditorStyle �������ɾ��.
	/*
	///modified by zy 20180930  ZY0170  TDisplayOnly N:�ɱ༭,����editor����;Y: ���ɱ༭
    if (oneItem.TDisplayOnly=="N")
    {
	    this.editor=setEditorStyle(oneItem)
	}
	*/
	//modified BY ZY0201  ����ǰ�� formatter �����п��ܻḳֵwidth
    var style=oneItem.TStyle
	if (style!=="")
	{
		var style=style.split(",");
		for (var i=0;i<style.length;i++)
		{
			var onestyle=style[i].split(":");
			if (onestyle[0]=="width") this.width=parseFloat(onestyle[1]);
			else if (onestyle[0]=="align") this.align=onestyle[1];
		}
	}
	//text ����Ҫformatter����;
	//0:text,1:link,2:button,3:checkbox,4:icheckbox,5:switchbox,6:numberbox,7:combobox,
	//8:validatebox,9:combogrid,10:datebox,11:datetimebox,12:combotree,13:textare
	switch (oneItem.TDisplayType)
	{
		case '0':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'text',options:{}}
		    //ά��Ԥ����������һ��ͼ����ʾ.
		    if (oneItem.TImage=="") return
		    this.formatter =  function(value,row,index){
				    var curImage=oneItem.TImage
				    if (curImage.indexOf(".")<=0)
				    {
					    curImage=getAutoPic(row)
				    }
				    else
				    {
					    curImage="../scripts_lib/hisui-0.1.0/dist/css/icons/"+curImage
				    }
				    if (curImage=="") return ""
				    var html=""
				    html='<img border=0 complete="complete" src="'+curImage+'" />'+value;
				    return html
			    }
		break;
		case '1':
		    this.formatter =  function(value,row,index){
					var html=""
					var len=multipCol.length
					for (var i=0;i<len;i++)
					{
						var onehtml=oneFormatterHtml(value,row,index,multipCol[i])
						if (html=="")
						{
							html=onehtml
						}
						else
						{
							html=html+'&nbsp;&nbsp;'+onehtml
						}
					}
					return html;
				}
		break;
		case '2':
		    this.formatter =  function(value,row,index){
					var html=""
					if (oneItem.TLookupJavascriptFunction=="") return
					if (oneItem.TDescription!="")
					{
						//add by zx 2018-11-09 ��ť��Ϊhisui��ʽ
						html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.description+'</a>'
						//html='<button id="'+oneItem.TName+'z'+index+'" type="button" onclick="'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.description+'</button>';
					}
					else
					{
						//add by zx 2018-11-09 ��ť��Ϊhisui��ʽ
						html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.title+'</a>'
						//html='<button id="'+oneItem.TName+'z'+index+'" type="button" onclick="'+oneItem.TLookupJavascriptFunction+'('+index+')">'+this.title+'</button>';
					}
					return html;
				}
		break;
		case '3':
		//modify by lmm 2020-03-06 begin LMM0062
		    if (oneItem.TDisplayOnly!="Y") 
		    {
			    
			    this.editor={type: 'checkbox',options:{on:'Y',off:'N'}}
			    var disable=""
		    }
		    else
		    {
			    var disable="disabled"
			}
		    this.formatter =  function(value,row,index){
					var html=""
					//if (oneItem.TLookupJavascriptFunction=="") return			Mozy0242	2020-01-02	1143943
					html=checkBox(value,oneItem.TLookupJavascriptFunction,this.field,index,disable)
					return html;
		//modify by lmm 2020-03-06 begin LMM0062
				}
		break;
		case '4':
		    if (oneItem.TDisplayOnly!="Y") {this.editor={type: 'icheckbox',options:{on:'Y',off:'N'}}}
		    //modified by LMM 2020-04-16 ȥ����ѡ��ȡ���༭Ϊ��ֵ״̬
		    this.checkbox=true
		break;
		case '5':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'switchbox',options:{on:'Y',off:'N'}}
		break;
		case '6':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'numberbox',options:{precision:2}}
		break;
		case '7':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'combobox',options:{}}
		break;
		case '8':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'validatebox',options:{}}
		break;
		case '9':
		    if (oneItem.TDisplayOnly!="Y")
		    {
				///modified by zy0172  hisui����  �޸����ļ���λ��
				var lookupinfo=tkMakeServerCall("web.DHCEQ.Plat.CTCComponentSet","GetComponentsInfo",oneItem.TLookupCustomComponent)
				var lookupObj=JSON.parse(lookupinfo)
				var componentInfo=lookupObj[oneItem.TLookupCustomComponent]
				if (componentInfo!="")
				{
					var objcomponent =new component(componentInfo)
			    	this.editor={type: 'combogrid',options:{
										panelWidth:400,
										mode: 'remote',
										pagination:true,
										lazy:true,
										showPageList:false,
										showRefresh:false,
										minQueryLen:1,
										isCombo:true,
										queryParams:{ClassName: objcomponent.className,QueryName: objcomponent.queryName},
										url: $URL,
										idField:objcomponent.idField,
										textField:objcomponent.textField,
										columns:objcomponent.columns,
									    onBeforeLoad:function(param){
											//�ж��˲�����
											if (oneItem.TLookupProperties!="") objcomponent.params=oneItem.TLookupProperties
											var option=objcomponent.params.split("#");
										    for (var i=0;i<option.length;i++)
										    {
											    var oneParaInfo=option[i].split("*");
											    //��ȡcombogrid�����ֵ
											    if(oneParaInfo[2]=="1") {param[oneParaInfo[0]]=param.q;}
												//��ȡĬ��ֵ  ����
												else if(oneParaInfo[2]=="2"){param[oneParaInfo[0]]=oneParaInfo[3];}
												//��ȡsessionֵ
												else if(oneParaInfo[2]=="3"){param[oneParaInfo[0]]=session[oneParaInfo[3]];}
												//ͨ��jsдgetParam����ȡֵ
												else if(oneParaInfo[2]=="5"){param[oneParaInfo[0]]=getParam(oneParaInfo[0]);}
												//��ȡ��������Ԫ��ֵ
												else{param[oneParaInfo[0]]=getElementValue(oneParaInfo[3]);}
											}
											return true;
										},
										onSelect:eval(oneItem.TLookupJavascriptFunction),
										//modified by ZY0213
										onChange:function (newValue, oldValue){
											if ((newValue=="")&&(oldValue!=""))
											{
												eval(oneItem.THold1)
											}
										}
									}
								}
				}
			}
		break;
		case '10':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'datebox',options:{}}
		break;
		case '11':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'datetimebox',options:{}}
		break;
		case '12':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'combotree',options:{}}
		break;
		case '13':
		    if (oneItem.TDisplayOnly!="Y") this.editor={type: 'textarea',options:{}}
		break;
		default:
		  	break;
	}
/*	//modified BY ZY0201  ����ǰ�� formatter �����п��ܻḳֵwidth
    var style=oneItem.TStyle
	if (style!=="")
	{
		var style=style.split(",");
		for (var i=0;i<style.length;i++)
		{
			var onestyle=style[i].split(":");
			if (onestyle[0]=="width") this.width=onestyle[1];
			else if (onestyle[0]=="align") this.align=onestyle[1];
		}
	}*/
}
///Add By DJ 2018-07-30
///����:��ȡԪ��ֵ
///���:vElementID Ԫ����
///����ֵ:Ԫ��ֵ
///˵��:getValueByIdΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function getElementValue(vElementID)
{
	return getValueById(vElementID)
}

///Add By DJ 2018-07-30
///����:Ԫ�ظ�ֵ
///���:vElementID Ԫ����
///����ֵ:Ԫ�ض���
///˵��:setValueByIdΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function setElement(vElementID,vValue)
{
	return setValueById(vElementID,vValue)


}
///add by lmm 2020-06-29
///������lookup�س���һ�����
function lookuptab(vElementID)
{		

	var inputs=$("input[class^=hisui-][disabled!=disabled],select[class^=hisui-][disabled!=disabled]")	
	for(var i = 0;i<inputs.length;i++)
	{ 
		if ((vElementID==inputs[i].id)&&(inputs[i].className.indexOf("lookup") != -1))
			{
				if(i==(inputs.length-1))
				{     
					 if ((inputs[0].className.indexOf("combobox-f") != -1)||(inputs[0].className.indexOf("datebox-f") != -1))
					 {
						$("#"+inputs[0].id).next('span').find('input').focus()
					}
					else
					{
						inputs[0].focus()
					}
				}
				else
				{
					 if ((inputs[i+1].className.indexOf("combobox-f") != -1)||(inputs[i+1].className.indexOf("datebox-f") != -1))
					 {
						$("#"+inputs[i+1].id).next('span').find('input').focus()
					}
					else
					{
						inputs[i+1].focus()
					}
				}
			}
	}

}

///Add By DJ 2018-07-06
///����:����Ԫ�ش��ֱ�����Ԫ�صı���������.
///���:vElementIDs ��Ҫ�����ñ������Ԫ������ ��ʽ:"Ԫ����1^Ԫ����2^.....^Ԫ����n"
///����ֵ:��
///˵��:setItemRequireΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function setRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],true)
	}
}
///Add By DJ 2018-07-06
///����:����Jsonֵ�������Զ�ӦԪ�ظ�ֵ
///���:{Ԫ����1:Ԫ��ֵ1,Ԫ����2:Ԫ��ֵ2,...Ԫ����n:Ԫ��ֵn}
///����ֵ:��
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		setElement(key,vJsonInfo[key])
	}
}
///Add By DJ 2018-07-30
///����:����Ԫ�ز�����
///���:vElementID Ԫ����
///		vValue true��ʾ������, false��ʾ����
///����ֵ:��
///˵��:disableById��enableByIdΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function disableElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			disableById(vElementID)
		}
		else
		{
			enableById(vElementID)
		}
	}
}

///Add By CZF0075 2020-02-25
///����:����Ԫ�ش��ֱ�����Ԫ���Ƿ����
///���:vElementIDs ��Ҫ�������Ƿ���õ�Ԫ������ ��ʽ:"Ԫ����1^Ԫ����2^.....^Ԫ����n"
///		vValue true��ʾ������, false��ʾ����
///����ֵ:��
function setDisableElements(vElementIDs,vValue)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		disableElement(ElementList[i],vValue)
	}
}

///Add By DJ 2018-07-30
///����:����ҳ������Ԫ��������������Ԫ�ز�����
///���:vExcludesids ����Ԫ�ش� ��ʽ:"Ԫ����1^Ԫ����2^....^Ԫ����n"
///����ֵ:��
function disableAllElements(vExcludesids)
{
	vExcludesids="^"+vExcludesids+"^"
	$(":input").each(function(){
		var id=$(this)[0].id;
		var obj=document.getElementById(id);
		if (obj)
		{
			var value=(vExcludesids.indexOf("^"+id+"^")<0)
			disableElement(id,value)
		}
	})
}
///Add By DJ 2018-07-06
///����:������������,��ɫ,������ȡ�༭�ֶ��嵥
///���:ApproveSetDR ��������RowID
///		CurRole ��ɫRowID
///		ActionCode ��������
///����ֵ:��
function initEditFields(ApproveSetDR,CurRole,ActionCode)
{
	if (ActionCode==null) ActionCode=""
    var EditFieldsInfo=tkMakeServerCall("web.DHCEQ.Plat.BUSApprove","GetRequiredFields",ApproveSetDR,CurRole,ActionCode)
	var EditFieldsObj=JSON.parse(EditFieldsInfo)
	if (EditFieldsObj.SQLCODE<0){messageShow("","","",EditFieldsObj.Data);return;}
	if (EditFieldsObj.Data=="") return
	var List=EditFieldsObj.Data.split("^");
	var Len=List.length;
	for (var i=0;i<Len;i++)
	{
		var infor=List[i];
		var infor=infor.split(",");
		ObjEditFields[i]=new editFieldInfo(infor[0],infor[1],infor[2],infor[3],infor[4],infor[5],infor[6]);
	}
}

///Add By DJ  2018-07-06
///����:���ɱ༭�ֶ���Ϣ
///���:RowID		DHCEQCRoleReqFields�༭�ֶα�RowID
///		FieldName	DHCEQCRoleReqFields�༭�ֶ�Ԫ����
///		TableName	DHCEQCRoleReqFields�༭�ֶζ�Ӧ����
///		MustFlag	�Ƿ���� Y��ʾ���� N��ʾ�Ǳ���
///		ListFlag	�Ƿ��б�Ԫ�� Y��ʾ�� N��ʾ��
///		FieldType	�༭�ֶ�����. 1�ı� 2���� 3���� 4��ֵ 5ʱ�� 6ѡ��
///		RowIDName	�б�Ԫ�ض�Ӧ��RowID��
///����ֵ:��
function editFieldInfo(RowID,FieldName,TableName,MustFlag,ListFlag,FieldType,RowIDName)
{
	this.RowID=RowID;
	this.FieldName=FieldName;
	this.TableName=TableName;
	this.MustFlag=MustFlag;
	this.ListFlag=ListFlag;
	this.FieldType=FieldType;	
	if (!RowIDName) RowIDName="";
	this.RowIDName=RowIDName;
	//������
	if (FieldType==3)
	{
		FieldName=getEditElementName(FieldName);
	}
	this.EditFieldName=FieldName;
	if (ListFlag=="Y")
	{
		this.FieldCaption=getColCaption(FieldName);
	}
	else
	{
		this.FieldCaption=getElementValue("c"+FieldName);
		var obj=document.getElementById("c"+FieldName);
		if (obj)
		{
			enableById(FieldName)
			if (MustFlag=="Y")
			{
				setRequiredElements(FieldName)
			}
		}
	}
}
///Add By DJ 2018-07-30
///����:����DRԪ������ȡ��Ӧ�༭Ԫ�ص�Name,
///���:DRName 
///HISUI����:�޸Ļ�ȡ��Ӧ�༭Ԫ�ص�Name�Ĺ��� QW20181023
function getEditElementName(DRName)
{
	var editElement="";
	var level=0;
	$('[id^='+DRName+'_]').each(function(){
		var EditElementName=$(this)[0].id;
		var EditSplit=EditElementName.split("_")
		if (EditSplit[EditSplit.length-1].indexOf("Desc")>=0)
		{ 
			level=4;
			editElement=EditElementName
		}
		else if (EditSplit[EditSplit.length-1].indexOf("Name")>=0)
		{ 
			if (level<4)
			{
				level=3;
				editElement=EditElementName
			}
		}
		else if (EditSplit[EditSplit.length-1].indexOf("Code")>=0)
		{
			if (level<3)
			{
				level=2;
				editElement=EditElementName
			}
		}
		else
		{
			if (level<2)
			{
				level=1;
				editElement=EditElementName
			}
		}
	})
	if (editElement=="")
	{
		editElement=DRName
		if (DRName.substr(DRName.length-2,2)=="DR")
		{
			editElement=DRName.substr(0,DRName.length-2)
			if (("#"+editElement).length<=0)
			{
				var EditInfo=t[-9232]
				EditInfo=EditInfo.replace("[Name]",editElement);
				messageShow("","","",EditInfo)
			}
		}
	}
	return editElement
}

///Add By DJ 2018-07-06
///����:��������Ԫ������ȡ��Ԫ�ص�Caption---��ȷ��
///���:colName �б�Ԫ����
///����ֵ:�б�Ԫ������Ӧ��������
function getColCaption(colName)
{
	var ComponentID=getElementValue("GetComponentID");
    var CaptionInfo=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetColumnCaption",ComponentID,colName,"Y")	//modified by csj 20190807 ��ӻ�ȡ����ж���������
    var CaptionObj=JSON.parse(CaptionInfo)
    if (CaptionObj.SQLCODE<0){messageShow("","","",CaptionObj.Data);return ""}
	return CaptionObj.Data;
}
///Add By DJ 2018-07-06
///����:��ʼ������ҳ���������ť.Ĭ������6��������ť,����ҵ������������ʾ��ǰ����ɲ���������ť��
///���:��
///����ֵ:��
function initApproveButton()
{
	var ApproveSetDR=getElementValue("ApproveSetDR");
	for (var i=1;i<=6;i++)
	{
		hiddenObj("BApprove"+i,1);
	}
	var nextStep=getElementValue("NextFlowStep");
	var curRole=getElementValue("CurRole");
	var nextRole=getElementValue("NextRoleDR");
	var RoleStep=getElementValue("RoleStep");
	///����ǰ�û���ɫ����һ����ɫһ��ʱ���ɲ���
	///��������������иò������ȡ����ȡ����ť����
	var CancelFlag=getElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj)
		{
			jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-back'});
			jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
			jQuery("#BCancelSubmit").linkbutton({text:'�˻�'}); //Modify By zx 2020-02-20 BUG ZX0076 �ı�ͳһ����
		}
		//����ܾ�ԭ�����������ֻ����
		disableElement("RejectReason",false);		
	}
	else
	{
		hiddenObj("BCancelSubmit",1)
		//����ܾ�ԭ�����������ֻ����
		disableElement("RejectReason",true);
	}
	//����ܾ�ԭ�����������ֻ����
	disableElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///����������ť���⼰�Ƿ����
    var ApproveFlowInfo=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveSet","GetApproveFlow",ApproveSetDR)
    var ApproveFlowObj=JSON.parse(ApproveFlowInfo)
    if (ApproveFlowObj.SQLCODE<0){messageShow("","","",ApproveFlowObj.Data);return;}
	var List=ApproveFlowObj.Data.split("^")
	for (var i=1;i<=List.length;i++)
	{
		var FlowInfo=List[i-1];
		var FlowList=FlowInfo.split(",");
		if ((curRole==nextRole)&&(nextStep==FlowList[0])&&(nextStep==RoleStep))
		{
			var obj=document.getElementById("BApprove"+nextStep);
			if (obj) 
			{
				jQuery("#BApprove"+nextStep).linkbutton({iconCls: 'icon-w-stamp'});
				jQuery("#BApprove"+nextStep).on("click", BApprove_Clicked);
				disableElement("EditOpinion",false);
				hiddenObj("BApprove"+i,0);
			}
		}
		else
		{
			hiddenObj("BApprove"+i,1);
		}
		//Modify By zx 2020-02-20 BUG ZX0076 ��ֹ��ֵ����ʽ�仯
		//setElement("BApprove"+i,FlowList[2])
		jQuery("#BApprove"+i).linkbutton({text:FlowList[2]});
	}
	return;
}

///Add By ZY 2019-10-18
///����:��ʼ������ҳ���������ť.Ĭ��һ����ť,��ˡ�
///���:��
///����ֵ:��
function initApproveButtonNew()
{
	var ApproveSetDR=getElementValue("ApproveSetDR");
	//2019-07-25
	for (var i=1;i<=6;i++)
	{
		hiddenObj("BApprove"+i,1);
	}
	var nextStep=getElementValue("NextFlowStep");
	var curRole=getElementValue("CurRole");
	var nextRole=getElementValue("NextRoleDR");
	var RoleStep=getElementValue("RoleStep");
	///����ǰ�û���ɫ����һ����ɫһ��ʱ���ɲ���
	///��������������иò������ȡ����ȡ����ť����
	var CancelFlag=getElementValue("CancelFlag");
	if ((curRole==nextRole)&&(CancelFlag=="Y")&&(nextStep==RoleStep))
	{
		var obj=document.getElementById("BCancelSubmit");
		if (obj)
		{
			jQuery("#BCancelSubmit").linkbutton({text:"�˻�"});    //modify by lmm 2019-11-22 LMM0050
			jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-back'});
			jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
		}
		//����ܾ�ԭ�����������ֻ����
		disableElement("RejectReason",false);		
	}
	else
	{
		hiddenObj("BCancelSubmit",1)
		//����ܾ�ԭ�����������ֻ����
		disableElement("RejectReason",true);
	}
	//����ܾ�ԭ�����������ֻ����
	disableElement("EditOpinion",true);
	
	if (ApproveSetDR=="") return;
	
	///����������ť���⼰�Ƿ����
    var ApproveFlowInfo=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveSet","GetApproveFlow",ApproveSetDR)
    var ApproveFlowObj=JSON.parse(ApproveFlowInfo)
    if (ApproveFlowObj.SQLCODE<0){messageShow("","","",ApproveFlowObj.Data);return;}
	var List=ApproveFlowObj.Data.split("^")
	for (var i=1;i<=List.length;i++)
	{
		var FlowInfo=List[i-1];
		var FlowList=FlowInfo.split(",");
		if ((curRole==nextRole)&&(nextStep==FlowList[0])&&(nextStep==RoleStep))
		{
			//SetCElement("BApprove",FlowList[2]);
			//SetCElement("BApprove","���");
			//var obj=document.getElementById("BApprove"+nextStep);
			//$("#BApprove1").linkbutton({text:FlowList[2]})
			$("#BApprove1").linkbutton({text:"ͨ��"})
			var obj=document.getElementById("BApprove1");
			if (obj) 
			{
				//jQuery("#BApprove"+nextStep).linkbutton({iconCls: 'icon-w-stamp'});
				//jQuery("#BApprove"+nextStep).on("click", BApprove_Clicked);
				//hiddenObj("BApprove"+i,0);
				jQuery("#BApprove1").linkbutton({iconCls: 'icon-w-stamp'});
				jQuery("#BApprove1").on("click", BApprove_Clicked);
				disableElement("EditOpinion",false);
				setElement("EditOpinion","ͬ��");
				hiddenObj("BApprove1",0);
			}
		}
		/*
		else
		{
			hiddenObj("BApprove"+i,1);
		}
		setElement("BApprove"+i,FlowList[2])
		*/
	}
	return;
}
///Add By DJ 2018-07-30
///����:ҳ�����б�����Ԫ�ؼ��
///���:Strs:��Ϊ��ʱ��Strs�еı���Ԫ�ز���DR�Ƿ�Ϊ�յ���֤
///����ֵ:false��ʾ�ޱ�������Ҫ���� true��ʾ���ڱ�������Ҫ����
///˵��:checkMustItemNullΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function checkMustItemNull(Strs)
{
	if(checkMustLookupDRNull(Strs)) return true;  //add by lmm 2018-10-22
	var validateStrings=validateRequired();
	if (validateStrings=="")	return false;
	var value=validateStrings.split("^");
	var FirstName=value[0];
	var CValue=getElementValue("c"+FirstName);
	messageShow("","","",CValue+t[-9201]);
	return true;
}

///Add By DJ 2018-07-06
///����:�Զ����ɹ�������----��ȷ��
///���:type ϵͳ�������õĹ�������¼�뷽ʽ0 �Ŵ�ѡ��ģʽ��1 �ֹ�¼���Զ�����������ݣ�2 ����ģʽ����
///		i �б�Ԫ��ʱָ��ǰ��¼�к�
///����ֵ:��������RowID
function getFaultCaseRowID(type,i)
{		
	var FaultCaseName="MRFaultCaseDR_FCDesc"
	var FaultCaseDRName="MRFaultCaseDR"
	if ((i)&&(i!=""))
	{
		FaultCaseName="T"+FaultCase+"z"+i;
		FaultCaseDRName="T"+FaultCaseDRName+"z"+i;
	}	
	
 	if (getElementValue(FaultCaseDRName)!="")
 	{
  		return getElementValue(FaultCaseDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type==""))  return "";
	 	var FaultCase=getElementValue(FaultCaseName);
	 	if (FaultCase=="") return "";
	 	var val=getPYCode(FaultCase)+"^"+FaultCase;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultCase","UpdFaultCase",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///����:�Զ����ɹ���ԭ��----��ȷ��
///���:type ϵͳ�������õĹ���ԭ��¼�뷽ʽ0 �Ŵ�ѡ��ģʽ��1 �ֹ�¼���Զ�����������ݣ�2 ����ģʽ����
///		i �б�Ԫ��ʱָ��ǰ��¼�к�
///����ֵ:����ԭ��RowID
function getFaultReasonRowID(type,i)
{
	var FaultReasonName="MRFaultReasonDR_FRDesc";
	var FaultReasonDRName="MRFaultReasonDR";
	if ((i)&&(i!=""))
	{
		FaultReasonName="T"+FaultReasonName+"z"+i;
		FaultReasonDRName="T"+FaultReasonDRName+"z"+i;
	}
 	if (getElementValue(FaultReasonDRName)!="")
 	{
  		return getElementValue(FaultReasonDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultReason=getElementValue(FaultReasonName);
	 	if (FaultReason=="") return "";
	 	var val="^"+FaultReason;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultReason","UpdFaultReason",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///����:�Զ����ɽ������----��ȷ��
///���:type ϵͳ�������õĽ������¼�뷽ʽ0 �Ŵ�ѡ��ģʽ��1 �ֹ�¼���Զ�����������ݣ�2 ����ģʽ����
///		i �б�Ԫ��ʱָ��ǰ��¼�к�
///����ֵ:�������RowID
function getDealMethodRowID(type,i)
{
	var DealMethodName="MRDealMethodDR_DMDesc";
	var DealMethodDRName="MRDealMethodDR";
	if ((i)&&(i!=""))
	{
		DealMethodName="T"+DealMethodName+"z"+i;
		DealMethodDRName="T"+DealMethodDRName+"z"+i;
	}
	
 	if (getElementValue(DealMethodDRName)!="")
 	{
  		return getElementValue(DealMethodDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var DealMethod=getElementValue(DealMethodName);
	 	if (DealMethod=="") return "";
	 	var val="^"+DealMethod;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTDealMethod","UpdDealMethod",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-06
///����:�Զ����ɹ�������----��ȷ��
///���:type ϵͳ�������õĹ�������¼�뷽ʽ0 �Ŵ�ѡ��ģʽ��1 �ֹ�¼���Զ�����������ݣ�2 ����ģʽ����
///		i �б�Ԫ��ʱָ��ǰ��¼�к�
///����ֵ:��������RowID
function getFaultTypeRowID(type,i)
{
	var FaultTypeName="MRFaultTypeDR_FTDesc";
	var FaultTypeDRName="MRFaultTypeDR";
	if ((i)&&(i!=""))
	{
		FaultTypeName="T"+FaultTypeName+"z"+i;
		FaultTypeDRName="T"+FaultTypeDRName+"z"+i;
	}
	
 	if (getElementValue(FaultTypeDRName)!="")
 	{
  		return getElementValue(FaultTypeDRName);
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var FaultType=getElementValue(FaultTypeName);
	 	if (FaultType=="") return "";
	 	var val="^"+FaultType;
	    var rtn=tkMakeServerCall("web.DHCEQ.EM.CTFaultType","UpdFaultType",val)
	    var rtnObj=JSON.parse(rtn)
		if (rtnObj.SQLCODE<0) {messageShow("","","",rtnObj.Data);return rtnObj.SQLCODE;}
		return rtnObj.Data
 	}
}
///Add By DJ 2018-07-30
///����:tab��ǩҳѡ��
///���:vtabsname ��ǩ����
///		vtab ���ر�ǩ��
///����ֵ:��
function selectTab(vtabsname,vtab)
{
	if ((vtabsname=="")||(vtab=="")) return
	var tabindex=$("#"+vtabsname).tabs("getTabIndex","#"+vtab)
	$("#"+vtabsname).tabs("select",tabindex)
}
///Add By DJ 2018-07-30
///����:����tab��ǩҳ
///���:vtabsname ��ǩ����
///		vtab ���ر�ǩ��
///����ֵ:��
function hiddenTab(vtabsname,vtab)
{
	if ((vtabsname=="")||(vtab=="")) return
	var tabindex=$("#"+vtabsname).tabs("getTabIndex","#"+vtab)
	$("#"+vtabsname).tabs("close",tabindex)
}
///----��ȷ��
///Add By DJ 2018-07-30
///����:׷�����οؼ��ڵ�����
///���:vtree ���οؼ�Ԫ����
///		vid	 ׷�����ݽڵ�ID
///		vtext ׷����������
///		vparent ׷�����ݵĸ��ڵ�ID
///����ֵ:׷�ӽڵ����
function appendTree(vtree,vid,vtext,vparent)
{
	var treedata=[{"id":vid,"text":vtext}]
	if (vparent!="")
	{
		var parentObj=$("#"+vtree).tree("find",vparent)
		if (parentObj)
		{
			var FindObj=$("#"+vtree).tree("find",vid)
			if (!FindObj)
			{
				$("#"+vtree).tree('append', {parent:parentObj.target,data:treedata});
			}
		}
	}
	else
	{
		var FindObj=$("#"+vtree).tree("find",vid)
		if (!FindObj)
		{
			$("#"+vtree).tree('append', {data:treedata});
		}
	}
	return $("#"+vtree).tree("find",vid)
}

///add by lmm 2018-08-20
///������hisui���� ��ť��̳���Ϊ���֣��������ť�������а�ť����
///���:vExcludesids ��ʼ������Ԫ�� ��ʽ"Ԫ����1,Ԫ����2,....Ԫ����n"
function initButtonWidth(vExcludesids)
{
	var maxWidth=116 
	//������ťid��������
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			var width=$("#"+id).css("width");
			var width=width.substr(0,width.length-2)
			if (width>maxWidth) maxWidth=parseFloat(width)+2;
		}		
	})
	maxWidth=maxWidth+"px";
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			$("#"+id).css({"width":maxWidth})
		}		
	})
}

///Creator: zx
///CreatDate: 2018-09-02
///Description: hisui���title��ʽ����
function defindTitleStyle()
{
	$(".hisui-panel").each(function(){
		var iconCls="";
		var headerCls=""
		var options=$(this).attr("data-options");
		if ((options!=undefined)&&(options!=""))
		{
			//תjson��ʽ
			options='{'+options+'}';
			var options=eval('('+options+')');
			var eqTitle=options.eqtitle;
			//add by zx 2019-05-16  ZX0065 ���Ĭ�ϻᱻ��������޸�
			if ((eqTitle==undefined)||(eqTitle=="")) return;
			switch(eqTitle){
				case "maintitle":
					iconCls="icon-apply-check";
					headerCls="panel-header-gray";
				break;
				case "listtitle":
					iconCls="icon-add-note";
					headerCls="panel-header-gray";
				break;
				case "defaulttitle":
					iconCls="icon-paper";
					headerCls="panel-header-gray";
				break;
				case "savetitle":
					iconCls="icon-save";
					headerCls="panel-header-gray";
				break;
				case "edittitle":
					iconCls="icon-write-order";
					headerCls="panel-header-gray";
				break;
				default :
				break;
			}
		}
		$HUI.panel(this,{
			iconCls:iconCls,
			headerCls:headerCls
		});
	});
	
}

///Creator: zx
///CreatDate: 2018-09-13
///Description ʱ������Ϣ����
///Input options={id:'lifeInfoView',section:'',item:'^^content1%eq-user.png^^content2%eq-user.png^^content1'}
///      id:��Ԫ��ul��id section:������ģʽ ͼ��^����;icon^content 
///      item:ʱ����ڵ���Ϣ ͼ��^����^����;icon^url^content1%icon^url^content1%icon^url^content1
function createTimeLine(options)
{	
	var defaults = {
		id:'',
		section:'',
		item:'',
		lastFlag:'',
		onOrOff:'0'	//add by czf 2019-12-16 CZF0050
	};
    var options = jQuery.extend(defaults, options || {});
	if (options.id=="") return;
	var sectionHtml=""
	var html="";
	var liClass="eq-times-ul-li";
	if (options.onOrOff==1) liClass="eq-times-ul-li-off";	//add by czf 2019-12-16 CZF0050
	var curHtml=$("#"+options.id).html();
	if(options.section!="")
	{
		var sectionIcon=options.section.split("^")[0];
		var sectionContent=options.section.split("^")[1];
		sectionHtml=sectionHtml+'<div class="eq-times-section" style="background-image:url(../images/'+sectionIcon+')"><a>'+sectionContent+'</a></div>'; //��ݲ�һ��ʱ������ݷָ�
	}
	// add by zx 2020-02-12 ȡ��֮ǰȥ�����Ԫ�ر߿�Ĵ���ʽ ZX0073
	/*if (options.lastFlag!="")
	{
		if (curHtml=="") 
		{
			if(sectionHtml!="") liClass="eq-times-ul-li1";	//modified by czf 20190216 ֻ��һ���ڵ�ʱʱ������ʽ
			else liClass="eq-times-ul-li-noneborder1";
		}
		else liClass="eq-times-ul-li-noneborder2";
	}*/
	var pointStyle="eq-times-point"; //Ĭ�ϵ����ʽ
	if (options.onOrOff==1) pointStyle="eq-times-point-off";		//add by czf 2019-12-16 CZF0050
	if (curHtml=="")
	{
		pointStyle="eq-times-firstpoint";
		if (sectionHtml=="") html=html+'<li class="'+liClass+'" style="padding:0 0 10px 0;"><b class="'+pointStyle+'"></b>';
		else html=html+'<li class="'+liClass+'"><b class="'+pointStyle+'"></b>';
	}else{
		html=html+'<li class="'+liClass+'"><b class="'+pointStyle+'"></b>';
	}
	var singleItem=options.item.split("%");
	for (i=0;i<singleItem.length;i++)
	{
		var itemDetail=singleItem[i].split("^");
		var itemIcon=itemDetail[0];
		var itemUrl=itemDetail[1];
		var itemConten=itemDetail[2];
		if(itemIcon!=""){
			html=html+'<div class="eq-times-icon" style="background-image:url(../images/'+itemIcon+')">'+itemConten+'</div>';
		}else if(itemUrl!=""){
			html=html+'<p><a '+itemUrl+'>'+itemConten+'</a></p>';
		}else if(itemConten!=""){
			//add by czf 2019-12-16 CZF0050
			if (options.onOrOff==1) html=html+'<div style="color:#C0C0C0">'+itemConten+'</div>';
			else html=html+'<div>'+itemConten+'</div>';
		}
	}
	html=sectionHtml+html+'</li>';
	$("#"+options.id).append(html);
	//���һ���ڵ�߿���ð�ɫ�����ڵ� add by zx 2020-02-12 ZX0073
	if (options.lastFlag!="") 
	{
		var lastLiHeight=$("#"+options.id+" li:last-child").innerHeight(); //��ȡ���һ���ڵ�߶�
		var paddingValue=lastLiHeight/2; //����Ԫ�ص��ڱ߾ദ��
		var marginTopValue=-lastLiHeight+20; //����Ԫ�����ƾ���
		$("#"+options.id).append('<li class="eq-times-ul-li-last" style="padding:'+paddingValue+'px 0px;margin-top:'+marginTopValue+'px;"></li>')
	}
}
///modified by ZY0215 2020-04-02 �����������̵���ʾ
///Add By DJ 2018-09-14
function createApproveSchedule(vElementID,vApproveTypeCode,vSourceID)
{
	var ApproveSchedule=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetApproveSchedule",vApproveTypeCode,vSourceID)
	var ApproveScheduleObj=JSON.parse(ApproveSchedule)
	var ApproveScheduleInfo=ApproveScheduleObj["Data"]
	var ApproveFlow=ApproveScheduleInfo.split("^")
	///modified by ZY0215 2020-04-02 ȡ��ǰ����
	var Len=ApproveFlow.length
	var CurNode=""
	for (var i=0;i<Len;i++)
	{
		var OneInfo=ApproveFlow[i].split("=");
		if (OneInfo[1]==0)
		{
			CurNode=i
			break;
		}
	}
	var num=1	//���嵱ǰ����ǰ��������
	var html="" 
	var FrontMore="",FrontValue=""
	var AfterMore="",AfterValue=""
	for (var i=0;i<Len;i++)
	{
		var OneInfo=ApproveFlow[i].split("=");
		if ((i!==0)&&((i!==(Len-1))))
		{
			//if ((CurNode!="")&&((i<(CurNode-2))||(i>(CurNode+2)))) continue
			if (i<(CurNode-num))
			{
				if (FrontValue=="") FrontValue=OneInfo[0]
				else FrontValue=FrontValue+","+OneInfo[0]
				var FrontMore="<a href='#' id='FrontMore' style=\"color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;\">����...</a><a><img src='../images/eq-line-2.png'></a>"
				continue
			}
			else if ((i>(CurNode+num)))
			{
				if (AfterValue=="") AfterValue=OneInfo[0]
				else AfterValue=AfterValue+","+OneInfo[0]
				//href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark"
				var AfterMore="<a href='#' id='AfterMore' style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">����...</a><a><img src='../images/eq-line-1.png'></a>"
				continue
			}
		}
		if ((i>(CurNode-num)))FrontMore=""
		var captionhtml="<a style=\"color: #C0C0C0;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
		var imghtml="<a><img src='../images/eq-line-1.png'></a>"
		if (OneInfo[1]==1)
		{
			captionhtml="<a style=\"color: #40A2DE;font-size:16px;padding:0 10px 0px 10px;\">"+OneInfo[0]+"</a>"
			imghtml="<a><img src='../images/eq-line-2.png'></a>"
		}
		
		if (i==0)
		{
			html=captionhtml+imghtml
		}
		else if (i==(ApproveFlow.length-1))
		{
			if (AfterMore!="")  html=html+imghtml+AfterMore
			html=html+imghtml+captionhtml
		}
		else
		{
			if (FrontMore!="")  html=html+imghtml+FrontMore
			html=html+imghtml+captionhtml+imghtml
		}
	}
	$("#"+vElementID).append(html);
	//modified by ZY0215 2020-04-02 ���tooltip��ʾ
	setTooltip("FrontMore",FrontValue)
	setTooltip("AfterMore",AfterValue)
}
///����: zhangyu
///����: 2018-09-30
///bugZY0170
///����: ����datagridĳ�еĺϼ�
///Input: dgId   datagrid��ID
///       colName ��
function totalSum(dgId,colName) {
    var rows = $('#'+dgId).datagrid('getRows');
    var total = 0;
    for (var i = 0; i < rows.length; i++) {
        var colValue=rows[i][colName]
        if (colValue=="") colValue=0
        total += parseFloat(colValue);
    }
    return total;
}

///����: zhangyu
///bugZY0170
///����: 2018-09-30
///����: ����datagrid�е�formatter ������Ҫ��html 
///Input: value  
///       row			�ж���
///       index			������
///       oneItem		һ��Ԫ�ض���
///modify by lmm 2019-02-17 ����window����Ϊmodal���� ���ӵ������ߣ�ͼ�꣬���⣬�ߴ綨��
///modify by lmm 2019-02-19 ����ShowInNewWindow���� fun �ص�����
function oneFormatterHtml(value,row,index,oneItem)
{
	var html=""
	if (oneItem.TDisplayType=="1" )
	{
		var str=oneItem.TLinkExpression
		var newWidth=""
		var newHeight=""
		var newTitle="��ϸ"
		var newIcon="icon-w-paper"
		var newSize=""
		var newFun=""
		var showInNewWindow=oneItem.TShowInNewWindow
		if (showInNewWindow!="")
		{
			var newWindowInfo=showInNewWindow.split(",")
			for (var i=0;i<newWindowInfo.length;i++)
			{
				var oneInfo=newWindowInfo[i].split("=")
				if (oneInfo[0]=="width")
				{
					newWidth=oneInfo[1]
				}
				else if (oneInfo[0]=="height")
				{
					newHeight=oneInfo[1]
				}
				else if (oneInfo[0]=="title")
				{
					newTitle=oneInfo[1]
				}
				else if (oneInfo[0]=="icon")
				{
					newIcon=oneInfo[1]
				}
				else if (oneInfo[0]=="size")
				{
					newSize=oneInfo[1]
				}
				else if (oneInfo[0]=="fun")
				{
					newFun=oneInfo[1]
				}
			}
		}
		//add by lmm 2019-02-20 begin
		if (newFun=="")
		{
			newFun="&quot;&quot;"
			
		}
		//add by lmm 2019-02-20 end
		//var str="'&RowID='_rs.GetDataByName('msgID')_'&ReadOnly='_%Request.Get('ReadOnly')_'&vData='_%Request.Get('vData')_'&actionDesc='_rs.GetListDataByName('actionDesc')_'&actionCode='_rs.GetListDataByName('actionCode')_'&roles='_rs.GetListDataByName('roles')"
		//Modify By zx 2020-02-20 BUG ZX0076 ���Բ����ζ������js����
		if(typeof(str)=="undefined" || str=="")
		{
			if (oneItem.TLookupJavascriptFunction!="")
			{
				//Modify by zx 2020-04-22 BUG ZX0084
				if(oneItem.TTooltip=="")
				{
					html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')">'+oneItem.TDescription+'<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></a>'
				}
				else
				{
					html='<a href="#" id="'+oneItem.TName+'z'+index+'" class="hisui-linkbutton hover-dark" onclick="javascript:'+oneItem.TLookupJavascriptFunction+'('+index+')" title='+oneItem.TTooltip+' class="hisui-tooltip" data-options="position:'+"'bottom'"+'">'+oneItem.TDescription+'<img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></a>';
				}
			}
			return html;
		} 
		str=str.replace(/'/g,"")	//ȥ��������
		str=str.replace(/_/g,"")	//ȥ�����»���
		str=str.replace(/%Request.Get/g,"%")	//ȥ��
		str=str.replace(/rs.GetDataByName/g,"#")	//ȥ��
		str=str.replace(/rs.GetListDataByName/g,"@")	//ȥ��
		var arg=str.split("&")
		var para=""
		var paralist=""
		var initLen=0
		for (var i=1;i<arg.length;i++)
		{
			var oneArg=arg[i].split("=");
			var oneArgName=oneArg[0];
			var oneArgType=oneArg[1].substring(0,1);
			var oneArgValueDesc=oneArg[1].substring(2,oneArg[1].length-1);
			if (oneArgType=="%")
			{
				para=para+"&"+oneArgName+"="+getElementValue(oneArgValueDesc)
			}
			else if (oneArgType=="#")
			{
				$.each(row,function(key,val)
				{
					if (oneArgValueDesc==key) para=para+"&"+oneArgName+"="+val
				})
			}
			else if (oneArgType=="@")
			{
				$.each(row,function(key,val)
				{
					if (oneArgValueDesc==key)
					{
						//val='18,19,'
						var list=val.split(",")
						if (initLen==0) initLen=list.length-1
						paralist=paralist+"&"+oneArgName+"="+val
					}
				})
			}
			else
			{
				para=para+"&"+arg[i]
			}
		}
		var url=oneItem.TLinkUrl
		if (url.indexOf('?')==-1) url=url+"?"
		url=url+para
		if (paralist!="")
		{
			for (var i=1;i<=initLen;i++)
			{
				var oneurl=url
				var name="���"
				var list=paralist.split("&")
				for (var j=1;j<list.length;j++)
				{
					var oneArg=list[j].split("=")
					oneArgName=oneArg[0]
					oneArgValue=oneArg[1].split(",")
					if (oneArgName=="actionDesc")
					{
						if (oneArgValue[i]!="") name=oneArgValue[i]
					}
					oneurl=oneurl+"&"+oneArgName+"="+oneArgValue[i]
				}
   			 	html=html+'<A onclick="showWindow(&quot;'+oneurl+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#" style="margin-left:5px">'+name+'</A>';
			}
		}
		else
		{
			//html='<A onclick="openNewWindow(&quot;'+url+'&quot;,&quot;'+oneItem.TShowInNewWindow+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/'+oneItem.TImage+'" /></A>';
			if (oneItem.TImage!="")
			{
				//modified by zy 20190612 ZY0190
				if (oneItem.TTooltip==""){
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'"/></A>';
				}
				else{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#" title='+oneItem.TTooltip+' class="hisui-tooltip" data-options="position:'+"'bottom'"+'"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/'+oneItem.TImage+'" /></A>';
				}
			}
			else
			{
				if  (oneItem.TDescription!="")
				{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#">'+oneItem.TDescription+'</A>';
				}
				else
				{
					html='<A id="'+oneItem.TName+'z'+index+'" onclick="showWindow(&quot;'+url+'&quot;,&quot;'+newTitle+'&quot;,&quot;'+newWidth+'&quot;,&quot;'+newHeight+'&quot;,&quot;'+newIcon+'&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+newSize+'&quot;,'+newFun+')" href="#">'+value+'</A>';
				}
			}
		}
	}
	return html
}
///Add By JYP 2018-10-09
///����:����Ԫ�ش��ֱ��Ƴ�Ԫ�صı���������.
///���:vElementIDs ��Ҫ���Ƴ��������Ԫ������ ��ʽ:"Ԫ����1^Ԫ����2^.....^Ԫ����n"
///����ֵ:��
///˵��:setItemRequireΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function removeRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],false)
	}
}
///����: zhangyu
///bugZY0170
///����: 2018-09-30
///����: �Ƴ�һ��Datagrid�й�ѡ����Ҫɾ������
///Input: datagridID table id
function removeCheckBoxedRow(datagridID)
{ 
	var deleteRows=new Array();
	deleteRows=$('#'+datagridID).datagrid('getChecked');
	for(var i=0;i<deleteRows.length;i++)
	{
		var deleteRow=deleteRows[i];
		var deleteIndex=$('#'+datagridID).datagrid('getRowIndex',deleteRow);
		$('#'+datagridID).datagrid('deleteRow',deleteIndex)
	}
}

///add by lmm 2018-10-22
///������������������DRУ��
///��Σ�Strs��Ϊ��ʱ��Strs�еı���Ԫ�ز���DR�Ƿ�Ϊ�յ���֤
///modify by lmm 2018-10-23 ����if�ж�˳��
function checkMustLookupDRNull(Strs)
{
	var CValue=""
	$('input[type="HIDDEN"]').each(function(){
		var _t = $(this);
		var id = _t.attr("id");
		//console.log(id);  //modify by jyp 2018-12-28 ����̨���Դ�ӡȥ��
		var lookupId=""
		var id=String(id)
		if(id.lastIndexOf("_")>=0)
		{
			var lookupId=$("#"+id.substr(0,id.lastIndexOf("_"))).attr("id")	
		}		
		else if ($("#"+id.substr(0,id.length-2)).attr("id")!=undefined)
		{
			var lookupId=$("#"+id.substr(0,id.length-2)).attr("id")
		}
		if (($("#"+lookupId).attr("data-required")=="true")&&(_t.attr("value")==""))
		{
			if(Strs!=""&&Strs!=undefined)		//modified by czf 773715
			{
				if(StrIsInStrs(Strs,lookupId,"^")&&(trim(GetElementValue(lookupId))!=""))
				{
					return false;
				}
			}
			$("#"+lookupId+",#"+lookupId+"+span>.validatebox-text").addClass("validatebox-invalid");
			CValue=getElementValue("c"+lookupId);

			return false;
		}
		
	})	
	if(CValue!="")
	{
		messageShow("","","",CValue+t[-9201]);
		return true;	
	}
}
/// ����������ͳһ����
/// add by zx 2018-10-31
/// ������
/// 	url:��������url
/// 	title:���ڱ���
/// 	width:���,�ٷֱ�
/// 	height:�߶�,�ٷֱ�
/// 	icon:ͼ��
/// 	showtype:������ʽ modal:ģ̬��, window:window����, dialog:��ͨ���弴��ģ̬��
/// 	left:�������߾��� Ϊ��ʱ�������,֧�ְٷֱȸ�ֵ��
/// 	top:������ϱ߾��� Ϊ��ʱ�������,֧�ְٷֱȸ�ֵ��
///     size:�����ߴ� large:�󵯴�90% middle��Ĭ�ϵ���80% small��С���� 60% 70%
///     cfun�����÷���
/// add by zx 2018-11-30 �߶ȸ�Ϊ����������ڵİٷֱ�
/// add by zx 2019-01-24 ��,�߶Ȼ�ȡ��Ϊȡ�ɼ��������ӵ���λ����
/// add by lmm 2019-02-17 ���ӵ�����С����
/// add by lmm 2019-02-19 ���ӵ��÷���
/// modify by lmm 2020-06-02
/// ����height:3row(3��)  width:3col(3��)   size:fix1col  fix2col  fix3col  fix4col  fix4col(�̶��е���)
function showWindow(url,title,width,height,icon,showtype,left,top,size,cfun)
{
	//add by lmm 2020-06-02	
	if ((height!="")&&(height.toString().indexOf("row")>0))
	{
		var len=height.split("row")[0];
		
		var subrowheight="43.75"
		var height=subrowheight*len
		
	}
	if ((width!="")&&(width.toString().indexOf("col")>0))
	{
		var len=width.split("col")[0];
		//var subcolwidth="370"
		//var width=subcolwidth*len
		switch(len){
			case '1':width="400"; break;
			case '2':width="650"; break;
			case '3':width="1000"; break;
			case '4':width="1350"; break;   //modify by lmm 2020-06-11
			case '5':width="1600"; 	break;	
			default:width="1600"; 	break;
		}
		
		
		
	}

	//add by lmm 2020-06-11 ��ҳ���
	var htmlWidth=window.top.document.documentElement["clientWidth"]
	var htmlHeight =window.top.document.documentElement["clientHeight"]
	if (!(showtype)||(showtype=="")) showtype="modal"
	switch(showtype){
		//modify by lmm 2019-02-14 ���ڷ�����ʹ��
		/*
		case 'modal':
		if (width==""){width=$(window).width()*0.85; }
		else if (width.toString().indexOf("%")>0){
				//�������ڵĿ��;
				width=width.replace("%","")/100;
				width=$(window).width()*width; 
			}
		if (height==""){height=$(window).height()*0.9; }    
		else if (height.toString().indexOf("%")>0){
				//�������ڵĸ߶�;
				height=height.replace("%","")/100;
				height=$(window).height()*height;
			}
			//����ģ̬��div ����ͬһ���ڴ򿪲�ͨģ̬��������
			//id��Ϊ���������һ��,���ڵ�ͨһ�����ر�ģ̬��
			$(document.body).append('<div id="WinModalEasyUI" style="overflow:hidden;"></div>');
			$("#WinModalEasyUI").show();
			$HUI.window("#WinModalEasyUI",{
				iconCls:icon,
				resizable:true,
				width:width,
		        height:height,
				modal:true,
				closed: false,
				title:title,
				collapsible:false,  //add by zx 2019-01-24 
				minimizable:false,
				maximizable:false,
				left:left,
				top:top,
				onClose: function () {
					//�ر����Ƴ�ģ̬��div
			        $("#WinModalEasyUI").remove();
			    },
				content:'<iframe src="'+url+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>',
			});
			break;
			*/
		case 'window':
			var features="width="+width+",height="+height;  //���Ϊ�ٷֱ�
			websys_createWindow(url,title,features);   //ƽ̨����
			break;
		case 'modal':
			if (size=="verylarge")   {  if (width=="") width="1600"; if (height=="") height ="800"}
			if (size=="large")   {  if (width=="") width="1350"; if (height=="") height ="800"}   //modify by lmm 2020-06-11
			if (size=="middle")   {  if (width=="") width="1000"; if (height=="") height ="700"}
			if (size=="small")   {  if (width=="") width="650"; if (height=="") height ="700"}
			//modify by lmm 2020-06-11	����������ҳ������
			
			if (width>htmlWidth)
			{
				width=htmlWidth-50;
			}			
			if (height>htmlHeight)
			{
				height=htmlHeight-50;
			}

			//add by lmm 2020-06-02
			//5�й̶�����
			var options={
					url:url,
					title:title,
					iconCls:icon,
					modal:true,   //ģ̬��
					left:left,
					top:top,
					mth:cfun      //add by lmm 2019-02-19
				}
				
			if (width!=="") options.width=width	
			if (height!=="") options.height=height
				
			websys_showModal(options);  
			break;
		case 'dialog':	
			if (size=="verylarge")   {  if (width=="") width="1600"; if (height=="") height ="800"}
			if (size=="large")   {  if (width=="") width="1350"; if (height=="") height ="850"}   //modify by lmm 2020-06-11
			if (size=="middle")   {  if (width=="") width="1000"; if (height=="") height ="700"}
			if (size=="small")   {  if (width=="") width="650"; if (height=="") height ="700"}
			//add by lmm 2020-06-02
			//5�й̶�����
			//modify by lmm 2020-06-11	����������ҳ������
			if (width>htmlWidth)
			{
				width=htmlWidth-50;
			}			
			if (height>htmlHeight)
			{
				height=htmlHeight-50;
			}
			var options={
					url:url,
					title:title,
					iconCls:icon,
					modal:false,   //��ģ̬��
					left:left,
					top:top,
					mth:cfun      //add by lmm 2019-02-19
				}
			if (width!=="") options.width=width	
			if (height!=="") options.height=height				
			websys_showModal(options);  
				
			break;
		default:
			break;
	}
}
///Add By DJ 2018-11-02
function createdatagrid(componentID,queryParams,columns)
{
	$HUI.datagrid("#"+componentID,{
		url:$URL,
		queryParams:queryParams,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){LoadSuccess();}
	});
}

///add by zx 2018-11-20
/// �����رմ���
function closeWindow(type)
{
	switch(type){
		case 'modal':
			//parent.$('#WinModalEasyUI',parent.document).dialog('close'); modiied by czf 20190219
			websys_showModal("close");	
			break;
		default:
			break;
	}
}

///add by lmm 2019-02-20
///����ˢ��
function refreshWindow()
{
	location.reload();	

}


/// add by lmm 2019-09-01
/// ����:hisui������ʵ�ֻس���һ������� 
/// ��ע:�ı���,������,�����б�,���ڿ�,ʱ�����ʵ��,���ı���֧��
/// modify by lmm 2020-06-29 ȥ��lookup�س����
function muilt_Tab()
{
	var inputs=$("input[class^=hisui-][disabled!=disabled],select[class^=hisui-][disabled!=disabled]")	
	$("input[disabled!=disabled],select[disabled!=disabled]").keyup(function(){  
		var obj=$(this)
		var className = obj.prop("className");
		var curID=obj.parent().children(":first").attr("id");
		if (className.indexOf("combo-text") != -1) curID=obj.parent().parent().children(":first").attr("id");
		var event = event||window.event;
		var keyCode=event.which||event.keyCode
		if (keyCode==13)
		{
			if (tabflag==0)
			{
				for(var i = 0;i<inputs.length;i++)
				{    
					if ((curID==inputs[i].id)&&(inputs[i].className.indexOf("lookup") == -1))
					{
						// ��������һ�����򽹵�ص���һ�� 
						if(i==(inputs.length-1))
						{   
							 if ((inputs[0].className.indexOf("combobox-f") != -1)||(inputs[0].className.indexOf("datebox-f") != -1))
							 {
								$("#"+inputs[0].id).next('span').find('input').focus()
							}
							else if (inputs[i].className.indexOf("lookup") == -1)
							{
								inputs[0].focus()
							}
							
						}
						 else
						{    
							 if ((inputs[i+1].className.indexOf("combobox-f") != -1)||(inputs[i+1].className.indexOf("datebox-f") != -1))
							 {
								$("#"+inputs[i+1].id).next('span').find('input').focus()
							}
							else
							{
								inputs[i+1].focus()
								
							}
						}	
					}
				}
			}
			else
			{tabflag=0}
	}
	});		
}
/// ��������׼lookup�ص�����дֵ����
///�������ڣ�ID��NameΪTRowID����DescԪ����ΪIDԪ����+'_***'����
/// ����  BRManageLocDR_CTLOCDesc  ��  BRManageLocDR   ��Ӧ��PLAT.L.Loc����ʹ��
/// add by ZY0197 2019-11-27
/// ������
/// 	elementID:��������Ԫ��ID
/// 	rowData:ѡ��ĵ������ж���
function setDefaultElementValue(elementID,rowData)
{
	var elementID=elementID.substr(0,elementID.lastIndexOf("_"))
	setElement(elementID,rowData.TRowID)
}
//add by csj 2019-10-14
//���ݿɱ༭�ֶζ�̬�����б�ɱ༭�����
//��Σ�datagrid�б�jQuery����(����$('#DHCEQBuyPlan')��
//����ֵ -1���޿ɱ༭�б��ֶ� 0������
function setListEditable(objtbl)
{
	if(ObjEditFields.length>0){
		var dataGridColums = objtbl.datagrid("options").columns[0]
		var ListNameStr ="" 	//�б�ɱ༭�ֶ�ƴ��
		for(var i = 0;i < ObjEditFields.length; i++)
		{
			if(ObjEditFields[i].ListFlag=="N") continue
			ListNameStr==""?ListNameStr=ObjEditFields[i].FieldName:ListNameStr=ListNameStr+getElementValue("SplitRowCode")+ObjEditFields[i].FieldName
		}
		if(ListNameStr=="") return -1
		for(var i = 0;i < dataGridColums.length; i++){
			if(ListNameStr.indexOf(dataGridColums[i].field)==-1){
				dataGridColums[i].editor=undefined
			};
		}
		return 0
	}
	else return -1
}

//add by ZY0215 2020-04-02 
//����ҵ��ID��ȡ������¼,����ʱ����
//��Σ�vElementID �����Ԫ��
//		vBussType ҵ�����
//		vBussID ҵ��ID
function createApproveRecord(vElementID,vBussType,vBussID)
{
    var resultData=$.cm({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		QueryName:"GetApproveList",
		BussType:vBussType,
		SourceID:vBussID
		},false)
	$("#"+vElementID).empty();
	//var curYear=""
	//��ʱ�䵹��,�����ֵ����
	for (var i=0;i<resultData.rows.length;i++)
	{
		var oneRecord=resultData.rows[i];
		var statusFlag=0
		var keyInfo=oneRecord.TApproveUser+" "+oneRecord.TAction+"�����������"+oneRecord.TOpinion
		if (oneRecord.TOperateType==1) keyInfo=oneRecord.TApproveUser+" "+oneRecord.TAction+"���ܾ����ܾ�ԭ��"+oneRecord.TOpinion
		if (oneRecord.TApproveRole!="") keyInfo=oneRecord.TApproveRole+" "+keyInfo
		var section="";
		var flag="";
		if(i==resultData.rows.length-1) flag=1;
		var ApproveDate=oneRecord.TApproveDate+" "+oneRecord.TApproveTime
		var ApproveInfo=""
		if(ApproveDate!=" ") 
		{
			ApproveInfo=ApproveDate+"��"+keyInfo
			opt={
				id:vElementID,
				section:section,
				item:'^^'+'%^^'+ApproveInfo,
				lastFlag:flag,
				onOrOff:statusFlag
			}
			createTimeLine(opt);
		}
	}
}

///add by lmm 2020-06-04
///������������ר�õ���
function colSetWindows(url)
{
	showWindow(url,"����������","","","icon-w-paper","","","","middle")  	
}
///Add By ZC0077 2020-06-24
///����:����Ԫ�ش��ֱ�ȡ��Ԫ�����õı���������.
///���:vElementIDs ��Ҫ��ȡ�����ñ������Ԫ������ ��ʽ:"Ԫ����1^Ԫ����2^.....^Ԫ����n"
///����ֵ:��
///˵��:setItemRequireΪƽ̨��������.λ��:"scripts/hisui/websys.hisui.js"
function RemoveRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],false)
	}
}