/// author zouxuan 2021-03-29
/// desc ����ģ����Ϣ
function initTemplateList(templateDR, rangeType, rangeID, styleType)
{
	//��ȡ״̬,�ǿջ�0ʱ���ɱ༭
	var status=parseInt(getElementValue("MTStatus"));
	$cm({
		ClassName:"web.DHCEQ.EM.BUSMaintPlan",
		QueryName:"GetTemplateList",
		Type:getElementValue("MTType"), //����
		TemplateDR:templateDR,
		RangeType:rangeType,
		RangeID:rangeID,
		MaintDR:getElementValue("MTRowID"),
		ItemFactorKey:"",
		GroupID:""
	},function(jsonData){
		var data=jsonData.rows;
		var jsonDataLength=data.length;
		$(".eq-template").empty();
		//alert(jsonDataLength)
		for (var i=0;i<jsonDataLength;i++)
		{
			console.log(data)
			if(i==0) $("#TemplateDesc").text(data[0].TTemplate);
			createTemplateList(i+1,data[i],status,styleType);
		}
		$.parser.parse(('.eq-template')); //���ɺ���������Ⱦ
		
		//keywords���
		$("span[name='spanclick']").click(function(){
			if (status) return;
			var parentObj=$(this).parent().parent();
			var itemDatetType=parentObj.attr("itemdatetype");  //��������
			var normalType=$(this).attr("normaltype");  //��ȡֵ����
			//bool����ʱ,��ʾ��ѡ,����ѡ����ʽ�ı�
			if(itemDatetType=="5")
			{
				$(parentObj).find("span").each(function(){
					this.style.backgroundColor="#AAAAAA";
					this.style.color="#FFFFFF";
					$(this).removeClass("eq-template-list-spanclick");
				});
				if (normalType=="1") $(this).parent().prev().css("color","red");
				else $(this).parent().prev().css("color","#666");
			}
			if ($(this).hasClass("eq-template-list-spanclick")){
				this.style.backgroundColor="#AAAAAA";
				this.style.color="#FFFFFF";
				$(this).removeClass("eq-template-list-spanclick");
			}else{
				this.style.backgroundColor="#40a2de";
				this.style.color="#FFFFFF";
				$(this).addClass("eq-template-list-spanclick");
			}
		})
		//��ѡ����
		$(".hisui-checkbox").change(function() {
			
      	})
      	//��ѡ����
      	$HUI.radio(".hisui-radio",{
	        onChecked:function(e,value){
		        var normalType=$(e.target).attr("normaltype");  //��ȡֵ����
		        if (normalType=="1") $(this).parent().prev().css("color","red");
				else $(this).parent().prev().css("color","#666");
	        }
	    });
      	//��������
      	$('.textbox:input').bind("input propertychange",function(event)
		{
		    var curValue=parseFloat($(this).val());
		    var minValue=parseFloat($(this).attr("minvalue"));
		    var maxValue=parseFloat($(this).attr("maxvalue"));
		    if ((minValue>curValue)||(maxValue<curValue)){
				 $(this).parent().prev().css("color","red");
			}else{
				$(this).parent().prev().css("color","#666");
			}
		});
	});
}

/// author zouxuan 2021-03-29
/// desc ����ģ����ϸ��Ϣ
function createTemplateList(row,data,status,styleType)
{
	var parentID="ChooseContent";
	var templateListDR=data.TRowID;
	var maintItemDR=data.TMaintItemDR;
	var itemCode=data.TItemCode;
	var itemDesc=data.TItemDesc;
	var itemItemCat=data.TItemItemCat;
	var itemDateType=data.TItemDateType;
	var itemDisplayType=data.TItemDisplayType;
	var itemMultiChoiceFlag=data.TItemMultiChoiceFlag;
	var defaultVal=data.TDefaultVal;
	var maintItemValues=JSON.parse(data.TMaintItemValues);
	var maintItemNormalValues=JSON.parse(data.TMaintItemNormalValues);
	var pmreportListDR=data.TPMReportListID;
	var pmreportListSort=data.TSort;
	var itemHtml='';
	switch(itemDisplayType){
		case '0':  //text
			if (styleType!="") parentID="EditContent"
			var elementHtml='';
			var colorStyle="";
			if(Object.keys(maintItemNormalValues).length>0)
			{
				if (Object.keys(maintItemNormalValues).length>1)
				{
					var singleItemDesc="";
					//����json�����ÿ��key/value��,pΪkey
					for(var p in maintItemNormalValues)
					{
						var item=maintItemNormalValues[p];
						var minValue=parseFloat(item.MinValue);
						var maxValue=parseFloat(item.MaxValue);
						var curValue=parseFloat(defaultVal);
						if ((minValue>curValue)||(maxValue<curValue)){
							colorStyle="color:red;";
						}
						var maintItemFactor=item.MaintItemFactor
						if (typeof(maintItemFactor) == "undefined") maintItemFactor="";
						elementHtml='valueType="'+item.ValueType+'" minvalue="'+item.MinValue+'" maintitemfactor="'+maintItemFactor+'" maxvalue="'+item.MaxValue+'" itemfactorkey="'+item.ItemFactorKey+'"';
						if (status) elementHtml=elementHtml+' disabled ="true"';
						if(singleItemDesc=="") singleItemDesc=itemDesc;
						var factorDesc=(typeof item.FactorDesc == 'undefined') ? "" : item.FactorDesc;
						var singleItemHtml='<div>'+factorDesc+'</div><div><input class="hisui-validatebox textbox" value="'+item.NormalValue+'" '+elementHtml+'></div>';	
						itemHtml=itemHtml+'<div class="eq-template-list" pmreportListDR="'+pmreportListDR+'"pmreportListSort="'+pmreportListSort+'"templateListDR="'+templateListDR+'" maintItemDR="'+maintItemDR+'" itemdatetype="'+itemDateType+'" itemdisplaytype="'+itemDisplayType+'">'+singleItemHtml+'</div>';
					}
					itemHtml='<div class="eq-template-list-combi"><div class="eq-template-list-combi-desc">'+singleItemDesc+'</div><div class="eq-template-list-combi-data">'+itemHtml+'</div></div>'
				}
				else
				{
					//����json�����ÿ��key/value��,pΪkey
					for(var p in maintItemNormalValues)
					{
						var item=maintItemNormalValues[p];
						var minValue=parseFloat(item.MinValue);
						var maxValue=parseFloat(item.MaxValue);
						var curValue=parseFloat(defaultVal);
						if ((minValue>curValue)||(maxValue<curValue)){
							colorStyle="color:red;";
						}
						var maintItemFactor=item.MaintItemFactor
						if (typeof(maintItemFactor) == "undefined") maintItemFactor="";
						elementHtml='valueType="'+item.ValueType+'" minvalue="'+item.MinValue+'" maintitemfactor="'+maintItemFactor+'" maxvalue="'+item.MaxValue+'" itemfactorkey="'+item.ItemFactorKey+'"';
						if (status) elementHtml=elementHtml+' disabled ="true"';
						var singleItemDesc=itemDesc;
						var singleItemHtml='<div>'+singleItemDesc+'</div><div><input class="hisui-validatebox textbox" value="'+item.NormalValue+'" '+elementHtml+'></div>';	
						itemHtml=itemHtml+'<div class="eq-template-list" pmreportListDR="'+pmreportListDR+'"pmreportListSort="'+pmreportListSort+'"templateListDR="'+templateListDR+'" maintItemDR="'+maintItemDR+'" itemdatetype="'+itemDateType+'" itemdisplaytype="'+itemDisplayType+'">'+singleItemHtml+'</div>';
					}
				}
			}
		break;
		case '1':  //link
		break;
		case '2':  //button
		break;
		case '3':  //checkbox
			var elementHtml='';
			var colorStyle="";
			if(Object.keys(maintItemValues).length>0)
			{
				//����json�����ÿ��key/value��,pΪkey
				for(var p in maintItemValues)
				{
				  	var item=maintItemValues[p];
				  	if(itemDateType=="5"){ //��ѡ
					  	elementHtml=elementHtml+'<input class="hisui-radio" type="radio" normaltype="'+item.NormalType+'" label="'+item.Desc+'" name="'+itemCode+'" value="'+item.Value+'"';
					  	if ((","+defaultVal+",").indexOf(","+item.Value+",")!=-1)
					  	{
						  	elementHtml=elementHtml+' checked ="checked"';
							if (item.NormalType=="1") colorStyle="color:red;";
						}
					  	if (status) elementHtml=elementHtml+' disabled ="true"';
					  	elementHtml=elementHtml+' data-options="radioClass:\'hischeckbox_square-blue\'">';
				  	}else if(itemDateType=="6"){ //��ѡ
					  	elementHtml=elementHtml+'<input class="hisui-checkbox" type="checkbox" normaltype="'+item.NormalType+'" label="'+item.Desc+'" name="'+itemCode+'" value="'+item.Value+'"';
					  	if ((","+defaultVal+",").indexOf(","+item.Value+",")!=-1)
					  	{
						  	elementHtml=elementHtml+' checked ="checked"';
							if (item.NormalType=="1") colorStyle="color:red;";
						}
					  	if (status) elementHtml=elementHtml+' disabled ="true"';
					  	elementHtml=elementHtml+'">';
					}
				}
				itemHtml='<div style="'+colorStyle+'">'+itemDesc+'</div><div>'+elementHtml+'</div>';
				itemHtml='<div class="eq-template-list" pmreportListDR="'+pmreportListDR+'"pmreportListSort="'+pmreportListSort+'"templateListDR="'+templateListDR+'" maintItemDR="'+maintItemDR+'" itemdatetype="'+itemDateType+'" itemdisplaytype="'+itemDisplayType+'">'+itemHtml+'</div>';
			}
		break;
		case '4':  //icheckbox
		break;
		case '5':  //switchbox
		break;
		case '6':  //numberbox
			if (styleType!="") parentID="EditContent"
			var elementHtml='';
			var colorStyle="";
			if(Object.keys(maintItemNormalValues).length>0)
			{
				//����json�����ÿ��key/value��,pΪkey
				for(var p in maintItemNormalValues)
				{
					var item=maintItemNormalValues[p];
					var minValue=parseFloat(item.MinValue);
				    	var maxValue=parseFloat(item.MaxValue);
				   	var curValue=parseFloat(defaultVal);
				    	if ((minValue>curValue)||(maxValue<curValue)){
						 colorStyle="color:red;";
					}
					var maintItemFactor=item.MaintItemFactor
					if (typeof(maintItemFactor) == "undefined") maintItemFactor="";
					elementHtml='valueType="'+item.ValueType+'" minvalue="'+item.MinValue+'" maintitemfactor="'+maintItemFactor+'" maxvalue="'+item.MaxValue+'" itemfactorkey="'+item.ItemFactorKey+'"';
					if (status) elementHtml=elementHtml+' disabled ="true"';
					var factorDesc=(typeof item.FactorDesc == 'undefined') ? "" : item.FactorDesc;
					if (factorDesc!="") itemDesc=itemDesc+":"+factorDesc;
					var singleItemHtml='<div style="'+colorStyle+'">'+itemDesc+'</div><div><input class="hisui-numberbox textbox" value="'+item.NormalValue+'" '+elementHtml+'></div>';
					itemHtml=itemHtml+'<div class="eq-template-list" pmreportListDR="'+pmreportListDR+'"pmreportListSort="'+pmreportListSort+'"templateListDR="'+templateListDR+'" maintItemDR="'+maintItemDR+'" itemdatetype="'+itemDateType+'" itemdisplaytype="'+itemDisplayType+'">'+singleItemHtml+'</div>';
				}
			}
		break;
		case '7':  //combobox
		break;
		case '8':  //validatebox
		break;
		case '9':  //combogrid
		break;
		case '10':  //datebox
		break;
		case '11':  //datetimebox
		break;
		case '12':  //combotree
		break;
		case '13':  //textare
		break;
		case '14':  //keywords
			var elementHtml='';
			var colorStyle="";
			if(Object.keys(maintItemValues).length>0)
			{
				//����json�����ÿ��key/value��,pΪkey
				for(var p in maintItemValues)
				{
				  	var item=maintItemValues[p];
				  	var curClass="";
				  	var curStyle="";
				  	if ((","+defaultVal+",").indexOf(","+item.Value+",")!=-1)
				  	{
					  	curClass="eq-template-list-spanclick";
					  	curStyle="background-color:#40a2de;color:#FFFFFF";
						if (item.NormalType=="1") colorStyle="color:red;";
				  	}
				  	elementHtml=elementHtml+'<span name="spanclick" valu="'+item.Value+'" normaltype="'+item.NormalType+'" class="'+curClass+'" style="'+curStyle+'">'+item.Desc+'</span>';
				}
				itemHtml='<div style="'+colorStyle+'">'+itemDesc+'</div><div>'+elementHtml+'</div>';
				itemHtml='<div class="eq-template-list" pmreportListDR="'+pmreportListDR+'"pmreportListSort="'+pmreportListSort+'"templateListDR="'+templateListDR+'" maintItemDR="'+maintItemDR+'" itemdatetype="'+itemDateType+'" itemdisplaytype="'+itemDisplayType+'">'+itemHtml+'</div>';
			}
		break;
		default:
		break;
	}
	$("#"+parentID).append(itemHtml);
}

/// author zouxuan 2021-03-29
/// desc ��ȡģ������
function getTemplateListValue()
{
	var allListValue="";
	$(".eq-template-list").each(function(){
		var listValue="";
		var pmreportListDR=$(this).attr("pmreportListDR");
		var pmreportListSort=$(this).attr("pmreportListSort");
		var templateListDR=$(this).attr("templateListDR");
		var maintItemDR=$(this).attr("maintItemDR");
		var itemDateType=$(this).attr("itemdatetype");
		var maintItemFactor="";
		var itemFactorKey="";
		switch(itemDateType){
			case '0':  //string
				listValue=$(this).find("input").val();
				maintItemFactor=$(this).find("input").attr("maintitemfactor");
				itemFactorKey=$(this).find("input").attr("itemfactorkey");
			break;
			case '1':  //int
				listValue=$(this).find("input").val();
				maintItemFactor=$(this).find("input").attr("maintitemfactor");
				itemFactorKey=$(this).find("input").attr("itemfactorkey");
			break;
			case '2':  //float
				listValue=$(this).find("input").val();
				maintItemFactor=$(this).find("input").attr("maintitemfactor");
				itemFactorKey=$(this).find("input").attr("itemfactorkey");
			break;
			case '3':  //date
			break;
			case '4':  //time
			break;
			case '5':  //bool
				var itemDisplayType=$(this).attr("itemdisplaytype");
				if(itemDisplayType=="14")
				{
					$(this).find("span").each(function(){
						if($(this).hasClass("eq-template-list-spanclick"))
						{
							if (listValue!="") listValue=listValue+",";
							listValue=listValue+$(this).attr("valu");
						}
					});
				}else{
					$(this).find("input:checked").each(function(){
						if (listValue!="") listValue=listValue+",";
						listValue=listValue+$(this).val();
					});
				}
			break;
			case '6':  //MultiChoice
				var itemDisplayType=$(this).attr("itemdisplaytype");
				if(itemDisplayType=="14")
				{
					$(this).find("span").each(function(){
						if($(this).hasClass("eq-template-list-spanclick"))
						{
							if (listValue!="") listValue=listValue+",";
							listValue=listValue+$(this).attr("valu");
						}
					});
				}else{
					$(this).find("input:checked").each(function(){
						if (listValue!="") listValue=listValue+",";
						listValue=listValue+$(this).val();
					});
				}
			break;
			case '7':  //ref
			break;
			default:
			break;
		}
		if (allListValue!="") allListValue=allListValue+"#";
		allListValue=allListValue+pmreportListDR+"^^"+maintItemDR+"^"+listValue+"^^^"+pmreportListSort+"^^^^"+itemFactorKey+"^^"+maintItemFactor;
	});
	return allListValue;
}