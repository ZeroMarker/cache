$(document).ready(function() {
	var OrdCatItemzLookupGrid;
	var OrdSubCatItemzLookupGrid;
	var ItemzLookupGrid;
	var EntrySelRowFlag=0;
	/*var itemdataDelim = "\u0004" //String.fromCharCode(4);
	var groupitemDelim = "\u001c" //String.fromCharCode(28);
	var tabgroupDelim = "\u0001" //String.fromCharCode(1);*/
    var MAXGROUPS=5;
	var demo = new Vue({
		el:"#main",
		data:function(){
			return {
				PreftabType:OrdTempGlobalObj.PreftabType,
				Context:OrdTempGlobalObj.XCONTEXT,
				SaveParam:OrdTempGlobalObj.SaveParam,
				NameAddTab:'', //新建表名
				TableNameList:[], //表名字
				TableNameSelectIndex:0,
				TableNameSelectName:'',
				OrdCatDesc:'',
				OrdCatRowId:'',
				OrdSubDesc:'',
				OrdSubRowId:'',
				OrdNameDesc:'',
				OrdNameRowId:'',
				ListGroup1:[],
				ListGroup2:[],
				ListGroup3:[],
				ListGroup4:[],
				ListGroup5:[],
				//ListGroup:[],
				ListFocusIndex:'',
				CurrentMainteance:'',
				NameGroup1:'',
				NameGroup2:'',
				NameGroup3:'',
				NameGroup4:'',
				NameGroup5:'',
				UpdateTableData:[],
				itemdataDelim:"\u0004",
				groupitemDelim:"\u001c",
				tabgroupDelim:"\u0001",
				websysPrefId:'',
				IsHaveMenuAuthOrderOrgFav:OrdTempGlobalObj.IsHaveMenuAuthOrderOrgFav,
				CMFlag:OrdTempGlobalObj.CMFlag
				//isLocPrefType:'1'
			}
		},
		methods: {
			AddTableName:function(){
				if (this.NameAddTab==""){
					dhcsys_alert("请输入新表名称!");
					return false;
				}
				this.TableNameList.push({"value":""+"!!"+(this.TableNameList.length),"text":this.NameAddTab}); //{"value":value,"text":desc}
				this.TableNameSelectIndex=this.TableNameList.length-1;
				this.TableNameSelectName=this.NameAddTab;
				//成功添加之后清空表名字
				this.NameAddTab="";
				this.ClearTableDeatail();
				websys_setfocus("OrdCateGory");
			},
			TabNameMove:function(Type){
				if (this.TableNameSelectIndex===""){
					dhcsys_alert("请选中需要移动表名!");
					return false;
				}
				var Length=this.TableNameList.length;
				if (Length>0){
					for(index=0;index<this.TableNameList.length;index++){
						var value=this.TableNameList[index].value;
						if (value.split("!!")[1]==this.TableNameSelectIndex){
							if (Type=="Up"){
								    if (this.TableNameList[index-1]){
									    var tmpvalue=this.TableNameList[index-1].value;
										var tmptext=this.TableNameList[index-1].text;
										this.TableNameList[index-1].value=this.TableNameList[index].value; 
										this.TableNameList[index-1].text=this.TableNameList[index].text;
										
										this.TableNameList[index].value=tmpvalue;
										this.TableNameList[index].text=tmptext;
										this.TableNameSelectIndex=value.split("!!")[1];
									}else{
										dhcsys_alert("已在最上面");
					 					return false;
									}
									
							}else{
								if (this.TableNameList[index+1]){
									var tmpvalue=this.TableNameList[index+1].value;
									var tmptext=this.TableNameList[index+1].text;
									this.TableNameList[index+1].value=this.TableNameList[index].value; 
									this.TableNameList[index+1].text=this.TableNameList[index].text;
									
									this.TableNameList[index].value=tmpvalue;
									this.TableNameList[index].text=tmptext;
									
									this.TableNameSelectIndex=value.split("!!")[1];
								}else{
									dhcsys_alert("已在最下面");
					 				return false;
								}
									
							}
							this.SelTabName();
							
							break;
						}
				     }
				}else{
				    dhcsys_alert("没有数据需要移动!");
				    return false;
				}
			},
			TabNameDel:function(){
				var delTabIndex=this.TableNameSelectIndex;
				if (this.TableNameSelectIndex===""){
					dhcsys_alert("请选中需要删除的表名!");
					return false;
				}
				var afterDelArr=new Array();
				var MoveObj=$("select[name='TableNameList']");
					var length=MoveObj[0].options.length;
					if(length>0){ 
					for(index=0;index<length;index++)  {
						if(!MoveObj[0].options[index].selected){
							var value=MoveObj[0].options[index].value;
							var desc=MoveObj[0].options[index].text;
							afterDelArr.push({"value":value,"text":desc});
						}
					}
				}
				if (confirm("确定删除选中的表名吗？")) {
					var Rtn=tkMakeServerCall("web.DHCDocPrefTabs","websysDelOETabsNew",this.websysPrefId,delTabIndex)
					if (Rtn==0){
						dhcsys_alert("删除成功!")
					}else{
						dhcsys_alert("删除失败!")
					}
					this.TableNameList=afterDelArr;
					if (afterDelArr.length>0){
						this.TableNameSelectIndex=0;
						MoveObj[0].options[0].selected=true;
						this.TableNameSelectName=this.TableNameList[0].text;;
					}else{
						this.TableNameSelectIndex="";
						this.TableNameSelectName="";
					}
					this.SelTabName();
				}
				
				
			},
			TableNameListChange:function(e){
				var SelTab="",SelName="";
				var tableobj=e.target;
				$.each(tableobj,function(index,obj) {
					if (obj.selected) {
						if (SelTab=="") SelTab=obj.value.split("!!")[1];
						else SelTab=SelTab+"^"+obj.value.split("!!")[1];
						SelName=obj.text;
					};
				})
				this.TableNameSelectIndex=SelTab;
				var SelTab=this.TableNameSelectIndex.toString();
				var SelTabLen=SelTab.split("^").length;
				if ((SelTabLen==0)||(SelTabLen>1)){
					this.ClearTableDeatail();
				}else{
					this.TableNameSelectName=SelName;
					this.SelTabName();
				};
			},
			PreftabTypeClick:function(e){
				if (e.target.value=="User.SSUser"){
					if (e.target.checked) this.PreftabType="User.SSUser";
				}else{
					this.PreftabType="User.CTLoc";
				}
				OrdTempGlobalObj.PreftabType=this.PreftabType;
				this.LoadTempData();
			},
			CMFlagClick:function(e){
				this.Context="";
				if (e.target.checked) {
					this.CMFlag="CM";
					OrdTempGlobalObj.CMFlag="CM";
				}else{
					this.CMFlag="";
					OrdTempGlobalObj.CMFlag="";
				}
				this.SetContext();
				this.LoadTempData();
			},
			ListGroupFocus:function(e){
				/*var ListGroupSelObj=$("select[name='ListGroup"+"_"+this.ListFocusIndex+"']").find("option:selected");
				for (var i=0;i<ListGroupSelObj.length;i++){
					ListGroupSelObj[i].selected=0;
					ListGroupSelObj[i].selected=false;
				}*/
				if (this.ListFocusIndex=="1"){
					for (var i=0;i<this.ListGroup1.length;i++){
						this.ListGroup1[i].selected=0;
					}
				}
				if (this.ListFocusIndex=="2"){
					for (var i=0;i<this.ListGroup2.length;i++){
						this.ListGroup2[i].selected=0;
					}
				}
				if (this.ListFocusIndex=="3"){
					for (var i=0;i<this.ListGroup3.length;i++){
						this.ListGroup3[i].selected=0;
					}
				}
				if (this.ListFocusIndex=="4"){
					for (var i=0;i<this.ListGroup4.length;i++){
						this.ListGroup4[i].selected=0;
					}
				}
				if (this.ListFocusIndex=="5"){
					for (var i=0;i<this.ListGroup5.length;i++){
						this.ListGroup5[i].selected=0;
					}
				}
				var name=e.target.name;
				var focusIndex=name.split("_")[1];
				this.ListFocusIndex=focusIndex;
				
			},
			TabItemMove:function(Type){
				var ListFocusIndex=this.ListFocusIndex;
				if (ListFocusIndex==""){
					dhcsys_alert("请选则需要移动列!");
					return false;
				}
				var ListGroupSelObj=$("select[name='ListGroup"+"_"+ListFocusIndex+"']").find("option:selected");
				if ((ListGroupSelObj[0]==undefined)||(ListGroupSelObj[0].length==0)){
					dhcsys_alert("没有选择需要移动的数据!");
					return false;
				}
				var selIndexArr=new Array();
				selIndexArr.length=0;
				for (var i=0;i<ListGroupSelObj.length;i++){
						selIndexArr[ListGroupSelObj[0].index]=1;
					}
				
				if (this.ListFocusIndex==1) {
					var length=this.ListGroup1.length;
					
				}
				if (this.ListFocusIndex==2) {
					var length=this.ListGroup2.length;
				}
				if (this.ListFocusIndex==3) var length=this.ListGroup3.length;
				if (this.ListFocusIndex==4) var length=this.ListGroup4.length;
				if (this.ListFocusIndex==5) var length=this.ListGroup5.length;
				var MoveObj=$("select[name='ListGroup"+"_"+this.ListFocusIndex+"']");
				if (Type=="Left"){
					if (ListFocusIndex==1){
						dhcsys_alert("不能往左移动!");
						return false;
					}
					for(var index = length - 1 ; index >= 0 ; index--)  {
						if(MoveObj[0].options[index].selected){
							if (this.ListFocusIndex==2){
								var value=this.ListGroup2[index].value;
								var desc=this.ListGroup2[index].text;
								this.ListGroup2.splice(index,1);
								this.ListGroup1.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==3){
								var value=this.ListGroup3[index].value;
								var desc=this.ListGroup3[index].text;
								this.ListGroup3.splice(index,1);
								this.ListGroup2.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==4){
								var value=this.ListGroup4[index].value;
								var desc=this.ListGroup4[index].text;
								this.ListGroup4.splice(index,1);
								this.ListGroup3.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==5){
								var value=this.ListGroup5[index].value;
								var desc=this.ListGroup5[index].text;
								this.ListGroup5.splice(index,1);
								this.ListGroup4.push({"value":value,"text":desc,"selected":'1'});
							}
						}
					}
					this.ListFocusIndex=parseInt(this.ListFocusIndex)-1;
				}
				if (Type=="Right"){
					if (ListFocusIndex=="5"){
						dhcsys_alert("不能往右移动!");
						return false;
					}
					for(var index = length - 1 ; index >= 0 ; index--)  {
						if(MoveObj[0].options[index].selected){
							if (this.ListFocusIndex==1){
								var value=this.ListGroup1[index].value;
								var desc=this.ListGroup1[index].text;
								this.ListGroup1.splice(index,1);
								this.ListGroup2.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==2){
								var value=this.ListGroup2[index].value;
								var desc=this.ListGroup2[index].text;
								this.ListGroup2.splice(index,1);
								this.ListGroup3.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==3){
								var value=this.ListGroup3[index].value;
								var desc=this.ListGroup3[index].text;
								this.ListGroup3.splice(index,1);
								this.ListGroup4.push({"value":value,"text":desc,"selected":'1'});
							}
							if (this.ListFocusIndex==4){
								var value=this.ListGroup4[index].value;
								var desc=this.ListGroup4[index].text;
								this.ListGroup4.splice(index,1);
								this.ListGroup5.push({"value":value,"text":desc,"selected":'1'});
							}
						}
					}
					this.ListFocusIndex=parseInt(this.ListFocusIndex)+1;
				}
				if (Type=="Down"){
					for(var index = length - 2 ; index >= 0 ; index--)  {
						if ((MoveObj[0].options[index].selected)&&(selIndexArr[index])){
							if(!MoveObj[0].options[index+1].selected){
								if (this.ListFocusIndex==1){
									var selvalue=this.ListGroup1[index].value;
								    var seldesc=this.ListGroup1[index].text;
									this.ListGroup1[index].text=this.ListGroup1[index+1].text;
									this.ListGroup1[index].value=this.ListGroup1[index+1].value;
									this.ListGroup1[index].selected=0
									this.ListGroup1[index+1].text=seldesc;
									this.ListGroup1[index+1].value=selvalue;
									this.ListGroup1[index+1].selected=1
								}
								if (this.ListFocusIndex==2){
									var selvalue=this.ListGroup2[index].value;
								    var seldesc=this.ListGroup2[index].text;
									this.ListGroup2[index].text=this.ListGroup2[index+1].text;
									this.ListGroup2[index].value=this.ListGroup2[index+1].value;
									this.ListGroup2[index].selected=0
									this.ListGroup2[index+1].text=seldesc;
									this.ListGroup2[index+1].value=selvalue;
									this.ListGroup2[index+1].selected=1
								}
								if (this.ListFocusIndex==3){
									var selvalue=this.ListGroup3[index].value;
								    var seldesc=this.ListGroup3[index].text;
									this.ListGroup3[index].text=this.ListGroup3[index+1].text;
									this.ListGroup3[index].value=this.ListGroup3[index+1].value;
									this.ListGroup3[index].selected=0
									this.ListGroup3[index+1].text=seldesc;
									this.ListGroup3[index+1].value=selvalue;
									this.ListGroup3[index+1].selected=1
								}
								if (this.ListFocusIndex==4){
									var selvalue=this.ListGroup4[index].value;
								    var seldesc=this.ListGroup4[index].text;
									this.ListGroup4[index].text=this.ListGroup4[index+1].text;
									this.ListGroup4[index].value=this.ListGroup4[index+1].value;
									this.ListGroup4[index].selected=0
									this.ListGroup4[index+1].text=seldesc;
									this.ListGroup4[index+1].value=selvalue;
									this.ListGroup4[index+1].selected=1
								}
								if (this.ListFocusIndex==5){
									var selvalue=this.ListGroup5[index].value;
								    var seldesc=this.ListGroup5[index].text;
									this.ListGroup5[index].text=this.ListGroup5[index+1].text;
									this.ListGroup5[index].value=this.ListGroup5[index+1].value;
									this.ListGroup5[index].selected=0
									this.ListGroup5[index+1].text=seldesc;
									this.ListGroup5[index+1].value=selvalue;
									this.ListGroup5[index+1].selected=1
								}
							}
						}else{
							if (this.ListFocusIndex==1){
								this.ListGroup1[index].selected=0;
							}
							if (this.ListFocusIndex==2){
								this.ListGroup2[index].selected=0;
							}
							if (this.ListFocusIndex==3){
								this.ListGroup3[index].selected=0;
							}
							if (this.ListFocusIndex==4){
								this.ListGroup4[index].selected=0;
							}
							if (this.ListFocusIndex==5){
								this.ListGroup5[index].selected=0;
							}	
						}
					}
				}
				if (Type=="Up"){
					for(var index=1;index<length;index++)  {
						if ((MoveObj[0].options[index].selected)&&(selIndexArr[index])){
							if(!MoveObj[0].options.item(index-1).selected){
								if (this.ListFocusIndex==1){
									var selvalue=this.ListGroup1[index].value;
									var seldesc=this.ListGroup1[index].text;
									this.ListGroup1[index].text=this.ListGroup1[index-1].text;
									this.ListGroup1[index].value=this.ListGroup1[index-1].value;
									this.ListGroup1[index].selected=0
									this.ListGroup1[index-1].text=seldesc;
									this.ListGroup1[index-1].value=selvalue;
									this.ListGroup1[index-1].selected=1
								}
								if (this.ListFocusIndex==2){
									var selvalue=this.ListGroup2[index].value;
								    var seldesc=this.ListGroup2[index].text;
									this.ListGroup2[index].text=this.ListGroup2[index-1].text;
									this.ListGroup2[index].value=this.ListGroup2[index-1].value;
									this.ListGroup2[index].selected=0
									this.ListGroup2[index-1].text=seldesc;
									this.ListGroup2[index-1].value=selvalue;
									this.ListGroup2[index-1].selected=1
								}
								if (this.ListFocusIndex==3){
									var selvalue=this.ListGroup3[index].value;
								    var seldesc=this.ListGroup3[index].text;
									this.ListGroup3[index].text=this.ListGroup3[index-1].text;
									this.ListGroup3[index].value=this.ListGroup3[index-1].value;
									this.ListGroup3[index].selected=0
									this.ListGroup3[index-1].text=seldesc;
									this.ListGroup3[index-1].value=selvalue;
									this.ListGroup3[index-1].selected=1
								}
								if (this.ListFocusIndex==4){
									var selvalue=this.ListGroup4[index].value;
								    var seldesc=this.ListGroup4[index].text;
									this.ListGroup4[index].text=this.ListGroup4[index-1].text;
									this.ListGroup4[index].value=this.ListGroup4[index-1].value;
									this.ListGroup4[index].selected=0
									this.ListGroup4[index-1].text=seldesc;
									this.ListGroup4[index-1].value=selvalue;
									this.ListGroup4[index-1].selected=1
								}
								if (this.ListFocusIndex==5){
									var selvalue=this.ListGroup5[index].value;
								    var seldesc=this.ListGroup5[index].text;
									this.ListGroup5[index].text=this.ListGroup5[index-1].text;
									this.ListGroup5[index].value=this.ListGroup5[index-1].value;
									this.ListGroup5[index].selected=0
									this.ListGroup5[index-1].text=seldesc;
									this.ListGroup5[index-1].value=selvalue;
									this.ListGroup5[index-1].selected=1
								}
							}
						}else{
							if (this.ListFocusIndex==1){
								this.ListGroup1[index].selected=0;
							}
							if (this.ListFocusIndex==2){
								this.ListGroup2[index].selected=0;
							}
							if (this.ListFocusIndex==3){
								this.ListGroup3[index].selected=0;
							}
							if (this.ListFocusIndex==4){
								this.ListGroup4[index].selected=0;
							}
							if (this.ListFocusIndex==5){
								this.ListGroup5[index].selected=0;
							}	
						}
					}
				}
			},
			TabItemDel:function(){
				if (this.ListFocusIndex==""){
					dhcsys_alert("请选中需要删除数据的列!");
					return false;
				}
				var ListGroupSelObj=$("select[name='ListGroup"+"_"+this.ListFocusIndex+"']").find("option:selected");
				if ((ListGroupSelObj[0]==undefined)||(ListGroupSelObj[0].length==0)){
					dhcsys_alert("没有选择需要删除的数据!");
					return false;
				}
				var afterDelArr=new Array();
				var MoveObj=$("select[name='ListGroup"+"_"+this.ListFocusIndex+"']");
					var length=MoveObj[0].options.length;
					if(length>0){ 
					for(index=0;index<length;index++)  {
						if(!MoveObj[0].options[index].selected){
							var value=MoveObj[0].options[index].value;
							var desc=MoveObj[0].options[index].text;
							afterDelArr.push({"value":value,"text":desc});
						}
					}
				}
				this.ReSetOneListGroupData(afterDelArr);
			},
			ReSetOneListGroupData:function(afterDelArr){
				if (this.ListFocusIndex==1){
					this.ListGroup1=[];
					this.ListGroup1=afterDelArr;
				}
				if (this.ListFocusIndex==2){
					this.ListGroup2=[];
					this.ListGroup2=afterDelArr;
				}
				if (this.ListFocusIndex==3){
					this.ListGroup3=[];
					this.ListGroup3=afterDelArr;
				}
				if (this.ListFocusIndex==4){
					this.ListGroup4=[];
					this.ListGroup4=afterDelArr;
				}
				if (this.ListFocusIndex==5){
					this.ListGroup5=[];
					this.ListGroup5=afterDelArr;
				}
			},
			copyToClipboard:function(){
				var DiagnosStr = 'DHCCA';
				for(k=1;k<6;k++){
					var obj=$("select[name='ListGroup"+"_"+k+"']");
					var length=obj[0].options.length;
					if(length>0){ 
						for(index=0;index<length;index++)  {
							if(obj[0].options[index].selected){
								var value=obj[0].options[index].value;
								var desc=obj[0].options[index].text;
								var lu=value.split(this.itemdataDelim);
								var type=lu[0],code=lu[1];
								if ((value != '') & (desc != '')) {
									DiagnosStr = DiagnosStr + "@@" + desc +'^'+code+'^'+type;
								}
							}
						}
					}
				}
				if(DiagnosStr=='DHCCA') {
				 	dhcsys_alert("请选择需要复制的项目!")
				 	return false;
			    }
				if(window.clipboardData) {   
		            window.clipboardData.clearData();   
		            window.clipboardData.setData("Text", DiagnosStr);
		            dhcsys_alert("复制成功");   
			    }
			},
			BPaste:function(){
				 if (this.ListFocusIndex=="") {
					 dhcsys_alert("请选择需要粘贴到的列!")
				 	 return false;
				 }
				 var PasteText=window.clipboardData.getData("text");
				 var PasteArray=PasteText.split("@@");
				 if (PasteArray[0]!='DHCCA'){dhcsys_alert('粘贴板里面的内容不是使用<复制医嘱>获得的数据');return}
				 for(i=1;i<PasteArray.length;i++){
					var lu=PasteArray[i].split("^");
					var DiagnosDesc=lu[0];
					var Diagnosvalue=lu[1];
					var type=lu[2];
					code = type+this.itemdataDelim+Diagnosvalue;
					if (this.ListFocusIndex==1){this.ListGroup1.push({"value":code,"text":DiagnosDesc});}
					if (this.ListFocusIndex==2){this.ListGroup2.push({"value":code,"text":DiagnosDesc});}
					if (this.ListFocusIndex==3){this.ListGroup3.push({"value":code,"text":DiagnosDesc});}
					if (this.ListFocusIndex==4){this.ListGroup4.push({"value":code,"text":DiagnosDesc});}
					if (this.ListFocusIndex==5){this.ListGroup5.push({"value":code,"text":DiagnosDesc});}
				}
				dhcsys_alert("粘贴结束");
			},
			CopyAllToClipboard:function(){
				var DiagnosStr=this.NameGroup1;
				DiagnosStr=DiagnosStr+"@@"+this.NameGroup2;
				DiagnosStr=DiagnosStr+"@@"+this.NameGroup3;
				DiagnosStr=DiagnosStr+"@@"+this.NameGroup4;
				DiagnosStr=DiagnosStr+"@@"+this.NameGroup5;
				DiagnosStr=DiagnosStr + 'DHCCCDHCCA';
				for(i=0;i<this.ListGroup1.length;i++){
					var value=this.ListGroup1[i].value;
					var text=this.ListGroup1[i].text;
					var lu=value.split(this.itemdataDelim);
					var type=lu[0],code=lu[1];
					if ((value != '') & (text != '')) {
						DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type;
					}
				}
				DiagnosStr = DiagnosStr + "DHCCBDHCCA";
				for(i=0;i<this.ListGroup2.length;i++){
					var value=this.ListGroup2[i].value;
					var text=this.ListGroup2[i].text;
					var lu=value.split(this.itemdataDelim);
					var type=lu[0],code=lu[1];
					if ((value != '') & (text != '')) {
						DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type;
					}
				}
				DiagnosStr = DiagnosStr + "DHCCBDHCCA";
				for(i=0;i<this.ListGroup3.length;i++){
					var value=this.ListGroup3[i].value;
					var text=this.ListGroup3[i].text;
					var lu=value.split(this.itemdataDelim);
					var type=lu[0],code=lu[1];
					if ((value != '') & (text != '')) {
						DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type;
					}
				}
				DiagnosStr = DiagnosStr + "DHCCBDHCCA";
				for(i=0;i<this.ListGroup4.length;i++){
					var value=this.ListGroup4[i].value;
					var text=this.ListGroup4[i].text;
					var lu=value.split(this.itemdataDelim);
					var type=lu[0],code=lu[1];
					if ((value != '') & (text != '')) {
						DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type;
					}
				}
				DiagnosStr = DiagnosStr + "DHCCBDHCCA";
				for(i=0;i<this.ListGroup5.length;i++){
					var value=this.ListGroup5[i].value;
					var text=this.ListGroup5[i].text;
					var lu=value.split(this.itemdataDelim);
					var type=lu[0],code=lu[1];
					if ((value != '') & (text != '')) {
						DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type;
					}
				}
				if(window.clipboardData) {   
		             window.clipboardData.clearData();   
		             window.clipboardData.setData("Text", DiagnosStr);
		             dhcsys_alert("复制成功");   
		        }
			},
			BPasteAll:function(){
				var PasteText=window.clipboardData.getData("text");
				var PasteHead=PasteText.split("DHCCC");
				if (PasteText.indexOf('DHCCCDHCCA')==-1){dhcsys_alert('粘贴板里面的内容不是使用<复制全部医嘱>获得的数据');return}
				var PasteHeadItem=PasteHead[0].split("@@");
				this.NameGroup1=PasteHeadItem[0];
				this.NameGroup2=PasteHeadItem[1];
				this.NameGroup3=PasteHeadItem[2];
				this.NameGroup4=PasteHeadItem[3];
				this.NameGroup5=PasteHeadItem[4];
				var PasteAllArray=PasteHead[1].split("DHCCB");
				for (k = 0; k < PasteAllArray.length; k++) {
					var Pasteitem=PasteAllArray[k]
		 			var PasteArray=Pasteitem.split("@@");
		 			if (PasteArray[0]!='DHCCA'){dhcsys_alert('粘贴板里面的内容不是科室诊断');return}
		 			if (k>5) return;
		 			for(i=1;i<PasteArray.length;i++){
			 			var lu=PasteArray[i].split("^");
						var desc=lu[0];
						var value=lu[1];
						var type=lu[2];
						code = type+this.itemdataDelim+value;
						if (k==0) this.ListGroup1.push({"value":code,"text":desc})
						if (k==1) this.ListGroup2.push({"value":code,"text":desc})
						if (k==2) this.ListGroup3.push({"value":code,"text":desc})
						if (k==3) this.ListGroup4.push({"value":code,"text":desc})
						if (k==4) this.ListGroup5.push({"value":code,"text":desc})
			 		}
				}
				dhcsys_alert("粘贴结束");
			},
			UpdateClickHandle:function(e){
				if (this.TableNameSelectIndex===""){
					dhcsys_alert("请选中需要修改的表名!");
					return false;
				}
				var SelTab=this.TableNameSelectIndex.toString();
				var SelTabLen=SelTab.split("^").length;
				if (SelTabLen==0){
					dhcsys_alert("请选中需要修改的表名!");
					return false;
				}else if(SelTabLen>1){
					dhcsys_alert("只能选择一个表进行修改!");
					return false;
				}
				var ListGroupData1=new Array(),
				    ListGroupData2=new Array(),
				    ListGroupData3=new Array(),
				    ListGroupData4=new Array(),
				    ListGroupData5=new Array();
				for (var i=0;i<this.ListGroup1.length;i++){
					var ItemID=this.ListGroup1[i].value;
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					ListGroupData1.push(ItemID)
				}
				for (var i=0;i<this.ListGroup2.length;i++){
					var ItemID=this.ListGroup2[i].value;
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					ListGroupData2.push(ItemID)
				}
				for (var i=0;i<this.ListGroup3.length;i++){
					var ItemID=this.ListGroup3[i].value;
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					ListGroupData3.push(ItemID)
				}
				for (var i=0;i<this.ListGroup4.length;i++){
					var ItemID=this.ListGroup4[i].value;
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					ListGroupData4.push(ItemID)
				}
				for (var i=0;i<this.ListGroup5.length;i++){
					var ItemID=this.ListGroup5[i].value;
					if(ItemID!="") ItemID=ItemID.replace("Y","");
					ListGroupData5.push(ItemID)
				}
				var arrLstItems = new Array(MAXGROUPS);
				arrLstItems[0]=this.NameGroup1+this.groupitemDelim+ListGroupData1.join(this.groupitemDelim)
				arrLstItems[1]=this.NameGroup2+this.groupitemDelim+ListGroupData2.join(this.groupitemDelim)
				arrLstItems[2]=this.NameGroup3+this.groupitemDelim+ListGroupData3.join(this.groupitemDelim)
				arrLstItems[3]=this.NameGroup4+this.groupitemDelim+ListGroupData4.join(this.groupitemDelim)
				arrLstItems[4]=this.NameGroup5+this.groupitemDelim+ListGroupData5.join(this.groupitemDelim)
				var UpdateVal = arrLstItems.join(this.tabgroupDelim);
				var TableNameList=new Array();
				for (var i=0;i<this.TableNameList.length;i++){
					var tableName=this.TableNameList[i].text;
					var Index=this.TableNameList[i].value.split("!!")[1];
					if (Index==this.TableNameSelectIndex){
						var NewTableName=$.trim(this.TableNameSelectName);
						if (NewTableName==""){
							dhcsys_alert("修改后的表名不能为空!");
							websys_setfocus("selTabName");
							return false;
						}else{
							tableName=NewTableName;
						}
					}
					TableNameList[i]=tableName+"^"+(parseInt(Index)+1);
				}
			    TableNameList=TableNameList.join("!!");
			    var objectType=this.PreftabType //"User.SSUser"
				var AppKey="ORDER";
				if (this.CMFlag=="CM"){
					AppKey=AppKey+OrdTempGlobalObj.CMDefaultContext;
				}else{
					AppKey=AppKey+OrdTempGlobalObj.XYDefaultContext;
				}
				if (this.PreftabType=="User.SSUser"){
					var objectReference=session['LOGON.USERID'];
					AppKey=AppKey+OrdTempGlobalObj.LocPrefType;
				}else{
					var objectReference=session['LOGON.CTLOCID'];
				}
			    var Rtn=tkMakeServerCall("web.DHCDocPrefTabs","websysSaveOETabsNew",this.websysPrefId,objectType,objectReference,AppKey,TableNameList,SelTab,UpdateVal);
				var rtn=Rtn.split("^")[0];
				var id=Rtn.split("^")[1];
				if (rtn==0){
					dhcsys_alert("更新成功!");
					this.websysPrefId=id;
					this.LoadTempData();
				}else{
					dhcsys_alert("更新失败!");
				}
			},
			OrdCatClick:function(e){
				try{
					var obj=websys_getSrcElement(e);
					var type=websys_getType(e);
					var key=websys_getKey(e);
					var OrdCatgoryDesc=this.OrdCatDesc.replace(/(^\s*)|(\s*$)/g,'');
			        var GroupID=session['LOGON.GROUPID'];
			        if (OrdCatItemzLookupGrid && OrdCatItemzLookupGrid.store) {
				        OrdCatItemzLookupGrid.searchAndShow([function() { return OrdCatgoryDesc; }, GroupID]);
				    } else {
				        OrdCatItemzLookupGrid = new dhcc.icare.Lookup({
				            lookupListComponetId: 1872,
				            lookupPage: "医嘱大类选择",
				            lookupName: obj.id,
				            listClassName: 'web.OECOrderCategory',
				            listQueryName: 'LookUpBySSGroup',
				            resizeColumn: true,
				            listProperties: [function() { return OrdCatgoryDesc; }, GroupID],
				            listeners: { 
				                'selectRow': this.OrderCategoryLookupSelect
				            },
				            isCombo: true
				        });
				    }
				 }catch(e){}
			},
			OrderCategoryLookupSelect:function(value){
				this.OrdCatRowId=value.split("^")[1];
				this.OrdCatDesc=value.split("^")[0];
				this.OrdSubRowId="";
				this.OrdSubDesc="";
				if (OrdSubCatItemzLookupGrid && OrdSubCatItemzLookupGrid.store) {
					OrdSubCatItemzLookupGrid.hide();
				}
				websys_setfocus("OrdSubCateGory");
			},
			OrdSubCatClick:function(e){
				try{
					var obj=websys_getSrcElement(e);
					var type=websys_getType(e);
					var key=websys_getKey(e);
					var OrdCatgoryDesc=this.OrdCatDesc;
					var OrdSubCatDesc=this.OrdSubDesc.replace(/(^\s*)|(\s*$)/g,'');
			        var GroupID=session['LOGON.GROUPID'];
			        if (OrdSubCatItemzLookupGrid && OrdSubCatItemzLookupGrid.store) {
				        OrdSubCatItemzLookupGrid.searchAndShow([function() { return OrdSubCatDesc; }, OrdCatgoryDesc,GroupID]);
				    } else {
				        OrdSubCatItemzLookupGrid = new dhcc.icare.Lookup({
				            lookupListComponetId: 1872,
				            lookupPage: "医嘱子类选择",
				            lookupName: obj.id,
				            listClassName: 'web.ARCItemCat',
				            listQueryName: 'LookUpByCategory',
				            resizeColumn: true,
				            listProperties: [function() { return OrdSubCatDesc; }, OrdCatgoryDesc,GroupID],
				            listeners: { 
				                'selectRow': this.OrderSubCatLookupSelect
				            },
				            isCombo: true
				        });
				    }
				}catch(e){}
			},
			OrderSubCatLookupSelect:function(value){
				this.OrdSubRowId=value.split("^")[1];
				this.OrdSubDesc=value.split("^")[0];
				this.OrdNameRowId="";
				this.OrdNameDesc="";
				if (ItemzLookupGrid && ItemzLookupGrid.store) {
				       ItemzLookupGrid.hide();
				 }
				websys_setfocus("OrderName");
			},
			OrdNameClick:function(e){
				try{
					var obj=websys_getSrcElement(e);
					var type=websys_getType(e);
					var key=websys_getKey(e);
				    var OrdNameDesc=this.OrdNameDesc.replace(/(^\s*)|(\s*$)/g,'');
				    if (key>64 && key<91){
					    OrdNameDesc=OrdNameDesc+e.key; //if (OrdNameDesc=="") 
					}
					if (ItemzLookupGrid && ((key == 27) || (OrdNameDesc == ""))) {
				        ItemzLookupGrid.hide();
				    }
				    if (OrdNameDesc == "") return;
					if (key == 13) {
				        if (EntrySelRowFlag==0) {
					        this.xItem_lookuphandlerX(obj.id,OrdNameDesc);
				        }else{
					        EntrySelRowFlag=0;
					    }
				    }
				    //else{
					    if ((type == 'dblclick')||((key>64 && key<91))||(obj.id=="OrderNameImage")) { //(OrdNameDesc.length>1)&&
						    this.xItem_lookuphandlerX(obj.id,OrdNameDesc);
					    }
					//}
				}catch(e){}
			},
			xItem_lookuphandlerX:function(id,OrdNameDesc){
				var CurLogonDep = session['LOGON.CTLOCID'];
				var GroupID = session['LOGON.GROUPID'];
				var OrdCatRowId=this.OrdCatRowId;
				if (this.OrdCatDesc=="") OrdCatRowId="";
				var OrdSubRowId=this.OrdSubRowId;
				if (this.OrdSubDesc=="") OrdSubRowId="";
				var P5 = "";
			    var LogonDep = ""
			    var OrderPriorRowid = "";
			    var P9 = "",P10 = "";
			    var OrdCatGrp = "";
			    //function() { return OrdNameDesc; }
			    if (ItemzLookupGrid && ItemzLookupGrid.store) {
			        setTimeout(function (){
				        ItemzLookupGrid.searchAndShow([OrdNameDesc, GroupID, OrdCatRowId, OrdSubRowId, P5, LogonDep, OrderPriorRowid, "", P9, P10, session["LOGON.USERID"], OrdCatGrp, "NonFormAndBrand", CurLogonDep]);
			        },1000);
			       		
				} else {
			        ItemzLookupGrid = new dhcc.icare.Lookup({
			            lookupListComponetId: 1872,
			            lookupPage: "医嘱选择",
			            lookupName: "OrderName",
			            listClassName: 'web.DHCDocOrderEntry',
			            listQueryName: 'LookUpItem',
			            resizeColumn: true,
			            listProperties: [function() { return $("#OrderName").val(); }, GroupID, OrdCatRowId, OrdSubRowId, P5, LogonDep, OrderPriorRowid, "", P9, P10, session["LOGON.USERID"], OrdCatGrp, "NonFormAndBrand", CurLogonDep],
			            listeners: { 
			                'selectRow': this.OrderLookupSelect 
			            },
			            isCombo: true,
			            selectRowRender:function(record){
				            //if (record) EntrySelRowFlag=1;
				        },
				        minLen:1
			        });
				}
				return websys_cancel();
			},
			OrderLookupSelect:function(value){
				EntrySelRowFlag=1;
				if (this.ListFocusIndex!=""){
					this.OrdNameRowId=value.split("^")[1];
					this.OrdNameDesc=value.split("^")[0];
					var OrdType=value.split("^")[3];
					var value=OrdType+this.itemdataDelim+this.OrdNameRowId;
					if (this.ListFocusIndex==1) {this.ListGroup1.push({"value":value,"text":this.OrdNameDesc});}
					if (this.ListFocusIndex==2) {this.ListGroup2.push({"value":value,"text":this.OrdNameDesc});}
					if (this.ListFocusIndex==3) {this.ListGroup3.push({"value":value,"text":this.OrdNameDesc});}
					if (this.ListFocusIndex==4) {this.ListGroup4.push({"value":value,"text":this.OrdNameDesc});}
					if (this.ListFocusIndex==5) {this.ListGroup5.push({"value":value,"text":this.OrdNameDesc});}
					this.OrdNameRowId="",this.OrdNameDesc=""
				}
			},
			SelTabName:function(){
				this.ClearTableDeatail();
				var SelTabs=this.TableNameSelectIndex.toString();
				if (SelTabs.split("^").length==1){
					var tempTableNameList=this.TableNameList;
					for (var m=0;m<tempTableNameList.length;m++){
						var tableNameIndex=tempTableNameList[m].value.split("!!")[1];
						if (tableNameIndex==SelTabs){
							var dataDetail=tempTableNameList[m].value.split("!!")[0];
							for (var i=0;i<dataDetail.split(this.groupitemDelim).length;i++){
								var ItemIndex=0;
								var tmpNameGroup=dataDetail.split(this.groupitemDelim)[i].split("::")[0];
								var tmpListGroupData=dataDetail.split(this.groupitemDelim)[i].split("::")[1];
								if ((tmpListGroupData=="")||(tmpListGroupData==undefined)) continue;
								if (i==0) this.NameGroup1=tmpNameGroup;
								if (i==1) this.NameGroup2=tmpNameGroup;
								if (i==2) this.NameGroup3=tmpNameGroup;
								if (i==3) this.NameGroup4=tmpNameGroup;
								if (i==4) this.NameGroup5=tmpNameGroup;
								for (j=0;j<tmpListGroupData.split("^").length;j++){
									var onegroup=tmpListGroupData.split("^")[j];
									var Desc=onegroup.split("!")[1].split(this.itemdataDelim)[1];
									var OrdType=onegroup.split("!")[1].split(this.itemdataDelim)[2];
									var itemrowid=onegroup.split("!")[1].split(this.itemdataDelim)[3];
							        var value=OrdType+this.itemdataDelim+itemrowid;
							        if ((value==undefined)||(Desc==undefined)||(value=="")||(Desc==""))continue;
							        if (i==0) this.ListGroup1.push({"value":value,"text":Desc});
							        if (i==1) this.ListGroup2.push({"value":value,"text":Desc});
							        if (i==2) this.ListGroup3.push({"value":value,"text":Desc});
							        if (i==3) this.ListGroup4.push({"value":value,"text":Desc});
							        if (i==4) this.ListGroup5.push({"value":value,"text":Desc});
								}
							}
							break;
						}
					}
				}
			},
			ClearTableDeatail:function(){
				//this.ListGroup1=Arr,this.ListGroup2=Arr,this.ListGroup3=Arr,this.ListGroup4=Arr,this.ListGroup5=Arr;
				this.ListGroup1=[],this.ListGroup2=[],this.ListGroup3=[],this.ListGroup4=[],this.ListGroup5=[];
				this.NameGroup1="",this.NameGroup2="",this.NameGroup3="",this.NameGroup4="",this.NameGroup5=""
		    },
		    SetContext:function(){
			    if (this.CMFlag=="CM"){
				    this.Context=OrdTempGlobalObj.CMDefaultContext;
				}else{
					this.Context=OrdTempGlobalObj.XYDefaultContext;
				}
				//if ((this.PreftabType=="User.SSUser")&&(this.isLocPrefType==1)){
				if (this.PreftabType=="User.SSUser"){
					var key="ORDER"+this.Context+OrdTempGlobalObj.LocPrefType;
				}else{
					var key="ORDER"+this.Context;
				}
			    this.Context=key;
			},
			LoadTempData:function(){
				this.TableNameList.length=0;
				this.ClearTableDeatail();
				var objectType=this.PreftabType //"User.SSUser"
				var AppKey="ORDER";
				if (this.CMFlag=="CM"){
					AppKey=AppKey+OrdTempGlobalObj.CMDefaultContext;
				}else{
					AppKey=AppKey+OrdTempGlobalObj.XYDefaultContext;
				}
				var AppSubKey=AppKey;
				if (this.PreftabType=="User.SSUser"){
					var objectReference=session['LOGON.USERID'];
					AppSubKey=AppSubKey+OrdTempGlobalObj.LocPrefType;
				}else{
					var objectReference=session['LOGON.CTLOCID'];
				}
				var allTabs=tkMakeServerCall("web.DHCDocPrefTabs","GetOETabItems",objectType,objectReference,AppSubKey);
				var websysPrefId=allTabs.split("!!")[1];
				this.websysPrefId=websysPrefId;
				if (allTabs.split("!!")[0]=="") {
					/*if (this.PreftabType=="User.SSUser"){
						this.isLocPrefType=0;
						var allTabs=tkMakeServerCall("web.DHCDocPrefTabs","GetOETabItems",objectType,objectReference,AppKey);
						var websysPrefId=allTabs.split("!!")[1];
						this.websysPrefId=websysPrefId;
						if (allTabs.split("!!")[0]=="") return;
					}else{
						return;
					}*/
					this.ClearTableDeatail();
					this.TableNameSelectName="";
					this.TableNameSelectIndex="";
					return;
				}
				var tabgroups=allTabs.split("!!")[0].split(",");
				for (var i=0;i<tabgroups.length;i++){
					var desc=tabgroups[i].split("@")[0]; 
					var value=tabgroups[i].split("@")[1]; 
					this.TableNameList.push({"value":value+"!!"+i,"text":desc});
					//this.TableNameSelectIndex=0;
					//if (i==0) this.TableNameSelectName=desc;
					if (this.TableNameSelectIndex==i){
						this.TableNameSelectName=desc;
					}
				}
				if (this.TableNameList.length>0) {
					this.SelTabName();
				}else{
					
				}
			}
		},
		watch: {
		},
		created: function () {
			this.LoadTempData();
		},
		compiled: function () { 
		console.log("编译完成");
		},
		computed:{
			getSaveParam:function(){
				if (this.PreftabType=="User.SSUser"){
					this.SaveParam=session['LOGON.USERNAME'];
				}else{
					this.SaveParam=OrdTempGlobalObj.LogCTLocDesc;
				}
				this.SetContext();
				if (this.Context===""){
					this.SaveParam=this.SaveParam;
				}else{
					this.SaveParam=this.SaveParam+"+"+this.Context;
				}
				return this.SaveParam;
			},
			getSaveParaTip:function(){
				var tips="正在维护 ";
				if (this.CMFlag=="CM"){
					tips=tips+"草药";
				}else{
					tips=tips+"西药";
				}
				if (this.PreftabType=="User.SSUser"){
					tips=tips+"个人";
				}else{
					tips=tips+"科室";
				}
				tips=tips+"模板";
				return tips;
			},
			getCurrMainteanceList:function(){
				var CurrMainteanceList="";
				if (this.ListFocusIndex==1) CurrMainteanceList="正在编辑列 "+this.NameGroup1;
				if (this.ListFocusIndex==2) CurrMainteanceList= "正在编辑列 "+this.NameGroup2;
				if (this.ListFocusIndex==3) CurrMainteanceList= "正在编辑列 "+this.NameGroup3;
				if (this.ListFocusIndex==4) CurrMainteanceList= "正在编辑列 "+this.NameGroup4;
				if (this.ListFocusIndex==5) CurrMainteanceList= "正在编辑列 "+this.NameGroup5;
				return CurrMainteanceList;
			}
		}
	})
	var MoveObj=$("select[name='TableNameList']");
	var length=MoveObj[0].options.length;
	if (length>0){
     MoveObj[0].options[0].selected=true;
    }
});