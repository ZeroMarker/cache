//页面Gui
function InitExpReportWin(){
	var obj = new Object();
	
    //项目分类
    var htmlP='',arrDT='',lenDT='';
    var TypeDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryExpRegType',RegTypeID);
    if (TypeDataQuery)  {
   		arrDT = TypeDataQuery.record;
   		lenDT = arrDT.length;
    }
    for (var indx = 0; indx < lenDT; indx++){
		var rd = arrDT[indx];
		if (!rd) continue;
		var TypeID   = rd["TypeID"];
		var TypeCode = rd["TypeCode"];
		var TypeDesc = rd["TypeDesc"];
		var IndNo    = rd["IndNo"];
		
		switch (TypeCode){
			case 'zzy': 
				imgType="职业史";
				break;
			case 'bls':
				imgType="暴露史";
				break;
			case 'blxx':
				imgType="暴露信息";
				break;
			case 'blyqk':
				imgType="暴露源情况";
				break;
			case 'fsjg':
				imgType="发生经过";
				break;
			case 'clcs':
				imgType="处理措施";
				break;
			case 'blfs':
				imgType="暴露方式";
				break;
			case 'czhj':
				imgType="操作环节";
				break;
			case 'blzz':
				imgType="暴露症状";
				break;
			case 'blqg':
				imgType="暴露评估";
				break;
	        case 'bljl':
				imgType="暴露结论";
				break;
			case 'blzsf':
				imgType="暴露者随访";
				break;
			case 'ygksf':
				imgType="感染科随访";
				break;
			default:
			    imgType="detailInfo";
			    break;
		}
	
		htmlP+='<div id='+TypeCode+' class="ExtType" data-id='+IndNo+'>'
		htmlP+='	<div class="report-header" style="margin-top:10px;">'
		htmlP+='  		<a class="Info"><img src="../scripts/dhchai/img/'+ imgType+ '.png"><span><strong>'+TypeDesc+' (标注为 <font color="#FF0000">*</font> 的项目为必填项)</strong></span></a>'
	    htmlP+='	</div>'
	    htmlP+='	<div class="content" >'
		htmlP+='		<div class="form-horizontal" id=Exp'+TypeCode+'>'
		htmlP+='		</div>'
	    htmlP+='	</div>'	
	    htmlP+='</div>'	 
    }
	$("#ExpExt").html(htmlP);
    
    //项目分类按排序码显示		
    var arrDOM = [], content = document.getElementById('ExpExt'), divs = content.getElementsByClassName('ExtType');
	for (i = 0; i < divs.length; i++) arrDOM[i] = divs[i];
	arrDOM.sort(function(a,b){return a.getAttribute('data-id') - b.getAttribute('data-id')});
	for (i in arrDOM) content.appendChild(arrDOM[i]);
    
    //项目定义
    for (var indy = 0; indy < lenDT; indy++){
		var rd = arrDT[indy];
		if (!rd) continue;
		var TypeID   = rd["TypeID"];
		var TypeCode = rd["TypeCode"];
		var ExtHtml = '';
		var TmpHtml = '';
		var lineList = '';
		var Count = 0;
		var ExtDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryExtByType',RegTypeID,TypeID);
        if(ExtDataQuery){
	        var arrExt = ExtDataQuery.record;
	        var lenExt = arrExt.length;
			for (var indExt = 0; indExt < lenExt; indExt++){
				var rdExt = arrExt[indExt];
				if (!rdExt) continue;
				var ExtID    = rdExt["ID"];
				var RegDesc  = rdExt["Desc"];
				var RegCode  = rdExt["Code"];
				var DataType = rdExt["DatCode"];
				var DicCode  = rdExt["DicCode"];
				var Required = rdExt["IsRequired"];
                var Line     = parseInt(RegCode);
                var Last     = RegCode.substring(5);
                var Indx     = RegCode.substring(4,6);
                var Num     = RegCode.substring(4,5);
                
                if (Last!=0) continue;
				
				if (DataType=="") {   //文字描述没有内容
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'    
					ExtHtml+='		<div class="form-label"><strong>'+RegDesc+'</strong></div>'
				    ExtHtml+='</div>'

				}
				else if (DataType=="DS") {  //单选字典
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'    
					ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'
					ExtHtml+='		<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-ctype="radio" data-span="3"></div>'
			    	ExtHtml+='</div>'
				}
				
				else if (DataType=="DSL") {  //单选长字典
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'    
					ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'
					ExtHtml+='		<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-ctype="radio" data-span="6"></div>'
			    	ExtHtml+='</div>'
				}
				else if (DataType=="DB") {  //多选字典			
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'   
					ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'
					ExtHtml+='		<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-span="3"></div>'
			    	ExtHtml+='</div>'
				}
				else if (DataType=="DBL") {   //多选长字典
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'    
					ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'
					ExtHtml+='		<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-span="6"></div>'
				    ExtHtml+='</div>'
				}
                else if ((DataType=="B1")||(DataType=="B2")) {  //有无/是否				
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'    
					ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'
					ExtHtml+='		<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-ctype="radio" data-span="3"></div>'
			    	ExtHtml+='</div>'
				}
                else if (DataType=="TL") {      //大文本
					ExtHtml+='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'   
	            	ExtHtml+='		<div class="form-label">'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</div>'	
					ExtHtml+='		<textarea id=txt'+RegCode+' " class="form-control new-comment-text"  rows="3" placeholder="'+RegDesc+'...'+'"></textarea>'
					ExtHtml+='</div>'			
				}
				else {
					if (DataType=="S") {       //下拉框
						TmpHtml ='     <div class="form-group-sm col-sm-3 col-xs-3">'   
						TmpHtml+='		     <label class="col-sm-4 col-xs-4 control-label" for=cbo'+RegCode+'>'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</label>'
						TmpHtml+='	         <div class="col-sm-8 col-xs-8">'
						TmpHtml+='	             <select class="form-control" id=cbo'+RegCode+'  name=cbo'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-param="'+DicCode+'^1" data-col="ID^DicDesc">'
						TmpHtml+='		     	 </select>'
						TmpHtml+='		     </div>'
						TmpHtml+='    </div>'					
					}

					if ((DataType=="T")||(DataType=="N0")||(DataType=="N1")) {   //文本、数值					
						TmpHtml ='     <div class="form-group-sm col-sm-3 col-xs-3">'   
						TmpHtml+='		     <label class="col-sm-4 col-xs-4 control-label" for=txt'+RegCode+'>'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</label>'
						TmpHtml+='	         <div class="col-sm-8 col-xs-8">'
						TmpHtml+='			     <input id=txt'+RegCode+' type="text" value="" name=txt'+RegCode+' class="form-control" />'
						TmpHtml+='		     </div>'
						TmpHtml+='    </div>'
					}
					
					if (DataType=="TB") {   //长文本						
						TmpHtml ='     <div class="form-group-sm col-sm-6 col-xs-6">'   
						TmpHtml+='		     <label class="col-sm-2 col-xs-2 control-label" for=txt'+RegCode+'>'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</label>'
						TmpHtml+='	         <div class="col-sm-10 col-xs-10">'
						TmpHtml+='			     <input id=txt'+RegCode+' type="text" value="" name=txt'+RegCode+' class="form-control" />'
						TmpHtml+='		     </div>'
						TmpHtml+='    </div>'
					}
					if (DataType=="DD") {  //日期
						TmpHtml ='     <div class="form-group-sm col-sm-3 col-xs-3">'   
						TmpHtml+='		     <label class="col-sm-4 col-xs-4 control-label" for=txt'+RegCode+'>'+((Required==1) ? '<strong><font color="#FF0000">*</font></strong>':'')+RegDesc+'</label>'
				        TmpHtml+='           <fieldset  class="col-sm-8 col-xs-8">'
						TmpHtml+='				<div class="input-group">'
						TmpHtml+='					<input id=txt'+RegCode+' class="form-control input-append date form_datetime ColisRequired" placeholder="">'
						TmpHtml+='					<span class="input-group-addon">'
						TmpHtml+='						<span class="icon-calendar"></span>'
						TmpHtml+='					</span>'
						TmpHtml+='				</div>'
						TmpHtml+='			</fieldset>'
				 		TmpHtml+='     </div>'
					}
					
					if (Num>0) {
						if (Count>Num) {
							ExtHtml += '</div>'  //最后一个项目结束
						}
						Count = Num;
						var line=Line-Indx;
					
						if (lineList.indexOf(line)<0) { //第一个项目
							var Html ='<div class="form-group ExpExt" id=Line'+line+' data-id='+line+'>'   
							ExtHtml += Html+TmpHtml
							lineList=lineList+","+line;
						}else {  //已经存在该行
							ExtHtml += TmpHtml
						}
						
					}else {	
					  var Html ='<div class="form-group ExpExt" id=Line'+Line+' data-id='+Line+'>'   	
				      ExtHtml += Html+TmpHtml+'</div>'
					}
					
				}
			}
        }
        $("#Exp"+TypeCode).html(ExtHtml);
       }
    
    //按编码排序显示
    for (var indz = 0; indz < lenDT; indz++){
		var rd = arrDT[indz];
		if (!rd) continue;
		var TypeID   = rd["TypeID"];
		var TypeCode = rd["TypeCode"];
		
	    var arrDOM = [], content = document.getElementById('Exp'+TypeCode), divs = content.getElementsByClassName('ExpExt');
	    for (i = 0; i < divs.length; i++) arrDOM[i] = divs[i];
	    arrDOM.sort(function(a,b){return a.getAttribute('data-id') - b.getAttribute('data-id')});
	    for (i in arrDOM) content.appendChild(arrDOM[i]);
	    
	    //备注文本
		var ExtDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryExtByType',RegTypeID,TypeID);
        if(ExtDataQuery){
	        var arrExt = ExtDataQuery.record;
	        var ParrefHtml = '';
	        var lenExt = arrExt.length;
	        var ChildHtml = '';
			for (var indExt = 0; indExt < lenExt; indExt++){
				var rdExt = arrExt[indExt];
				if (!rdExt) continue;
				var ExtID    = rdExt["ID"];
				var RegDesc  = rdExt["Desc"];
				var RegCode  = rdExt["Code"];
				var DataType = rdExt["DatCode"];
				var DicCode  = rdExt["DicCode"];
                var Line     = parseInt(RegCode);
                var Last     = RegCode.substring(5);
                
                if (Last==0) continue;
                
                if (DataType=="T"){	 //备注文本
					ChildHtml ='	<div class="col-sm-3 col-xs-3">' 
					ChildHtml+='		<input class="form-control" id=txt'+RegCode+' type="text" placeholder="'+RegDesc+'...'+'" />'
					ChildHtml+='	</div>'
					$("#Line"+(Line-Last)).append(ChildHtml);
				}
				if (DataType=="TB"){	 //长文本
					ChildHtml ='	<div class="col-sm-6 col-xs-6">' 
					ChildHtml+='		<input class="form-control" id=txt'+RegCode+' type="text" placeholder="'+RegDesc+'...'+'" />'
					ChildHtml+='	</div>'
					$("#Line"+(Line-Last)).append(ChildHtml);
				}
				if (DataType=="DS") {  //单选字典
					ChildHtml ='	<div class="col-sm-12 col-xs-12 form-label">'+RegDesc+'</div>'
					ChildHtml+='	<div class="row col-sm-12 col-xs-12" id=chk'+RegCode+' data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-col="ID^DicDesc" data-param="'+DicCode+'^1" data-ctype="radio" data-span="3"></div>'
				    $("#Line"+(Line-Last)).append(ChildHtml);
				}
				if(DataType=="TL") {      //大文本
		            ChildHtml ='	<div class=" col-sm-11 col-xs-11 form-label">'+RegDesc+'</div>'	
					ChildHtml+='	<textarea id=txt'+RegCode+' " class="form-control new-comment-text"  rows="3" placeholder="'+RegDesc+'...'+'"></textarea>'
					$("#Line"+(Line-Last)).append(ChildHtml);
				}
				
			}
        }
    }
  
    
    //检验
	var LabHtml='';
	var LabDataQuery = $.Tool.RunQuery('DHCHAI.IRS.OccExpTypeSrv','QryOccExpTypeLab',RegTypeID);
	if(LabDataQuery){
		var arrLab = LabDataQuery.record;
		var lenLab = arrLab.length;
		for (var ind = 0; ind < lenLab; ind++){
			var rd = arrLab[ind];
			if (!rd) continue;
			var ID=rd["ID"];
			var BTDesc  = rd["BTDesc"];
			var BTDays  = rd["BTDays"];
			var Resume  = rd["Resume"];
            var SubID = ID.split("||")[1];
        
            LabHtml+='<div class="form-group form-group-sm">'		
            
			LabHtml+='     <div class="form-group-sm col-sm-2 col-xs-2">'   
			LabHtml+='		     <label class="col-sm-8 col-xs-8 control-label" >'+BTDesc+'</label>'
			//LabHtml+='		     <label class="col-sm-4 col-xs-4 control-label" >'+BTDays+' 个月</label>'
			LabHtml+='		     <label class="col-sm-4 col-xs-4 control-label" >'+Resume+'</label>'
			LabHtml+='    </div>'
		
			LabHtml+='     <div class="form-group-sm col-sm-3 col-xs-3">'   
			LabHtml+='		     <label class="col-sm-3 col-xs-3 control-label" for="txtLabDate'+SubID+'">检验日期</label>'
	        LabHtml+='           <fieldset class="col-sm-9 col-xs-9">'
			LabHtml+='				<div class="input-group">'
			LabHtml+='					<input id="txtLabDate'+SubID+'" class="form-control input-append date form_datetime" placeholder="">'
			LabHtml+='					<span class="input-group-addon">'
			LabHtml+='						<span class="icon-calendar"></span>'
			LabHtml+='					</span>'
			LabHtml+='				</div>'
			LabHtml+='			</fieldset>'
	 		LabHtml+='     </div>'
	
			LabHtml+='     <div class="form-group-sm col-sm-3 col-xs-3">'   
			LabHtml+='		     <label class="col-sm-4 col-xs-4 control-label" for="txtLabItem'+SubID+'">检验项目</label>'
	        LabHtml+='	         <div class="col-sm-8 col-xs-8">'
			LabHtml+='			     <input id="txtLabItem'+SubID+'" type="text" value="" name="txtLabItem'+SubID+'" class="form-control" />'
			LabHtml+='		     </div>'
			LabHtml+='    </div>'
		
			LabHtml+='     <div class="form-group-sm col-sm-4 col-xs-4">'   
			LabHtml+='		     <label class="col-sm-3 col-xs-3 control-label" for="txtResult'+SubID+'">检验结果</label>'
	        LabHtml+='	         <div class="col-sm-9 col-xs-9">'
			LabHtml+='			     <input id="txtResult'+SubID+'" type="text" value="" name="txtResult'+SubID+'" class="form-control" />'
			LabHtml+='		     </div>'
			LabHtml+='    </div>'
				
			LabHtml+='</div>'
	      
		}
	}
	$("#ExpLabItem").html(LabHtml);	
	
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100
	});
	
	InitExpReportWinEvent(obj);
	return obj;
}