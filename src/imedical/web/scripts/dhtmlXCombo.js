 
var m_dhtmlXListSplitStr="$c(1)";
var m_dhtmlXValueSplitStr="$c(2)";
function dhtmlXComboFromStr(parent,str){
 if(typeof(parent)=="string")
 parent=document.getElementById(parent);
 var size=parent.offsetWidth;
 var z=document.createElement("SPAN");
 parent.parentNode.insertBefore(z,parent);
 parent.style.display='none';

 var s_type = parent.getAttribute('opt_type');

 var w= new dhtmlXCombo(z,parent.name,size,s_type);

 w.DOMelem_input.tabIndex=parent.tabIndex;
 w.DOMelem_input.style.fontSize=parent.style.fontSize;
 w.DOMelem_input.name=parent.name;
 w.DOMelem_input.id=parent.id;
 w.tagName="COMBO"
 w.tabIndex=parent.tabIndex;

 var x=new Array();
 //var sel=0;
 
 var Arr=str.split('^');
 for(var i=0;i<Arr.length;i++){
 	var Arr1=Arr[i].split(String.fromCharCode(1));
	var label=Arr1[1];
	var val=Arr1[0];
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i]=[val,label];
 }
 /*
 for(var i=0;i<parent.options.length;i++){
 if(parent.options[i].selected)sel=i;
 var label=parent.options[i].innerHTML;
 var val=parent.options[i].getAttribute("value");
 if((typeof(val)=="undefined")||(val===null))val=label;
 x[i]=[val,label];
}
*/
 var sel=-1;
 w.addOption(x);
 parent.parentNode.removeChild(parent);
 w.selectOption(sel);
 return w;
}
 
/*
	*****************************************************************************************
	Arrary String 
	RowID, Text, SelectIdx
	*****************************************************************************************
*/

function dhtmlXComboArray(parent,str){
 	if(typeof(parent)=="string")
 parent=document.getElementById(parent);

 var size=parent.offsetWidth;
 var z=document.createElement("SPAN");
 parent.parentNode.insertBefore(z,parent);
 parent.style.display='none';

 var s_type = parent.getAttribute('opt_type');

 var w= new dhtmlXCombo(z,parent.name,size,s_type);

 w.DOMelem_input.tabIndex=parent.tabIndex;
 w.DOMelem_input.name=parent.name;
 w.DOMelem_input.id=parent.id;
 w.tabIndex=parent.tabIndex;
 w.DOMelem_input.style.fontSize=parent.style.fontSize; 

 
 var x=new Array();
 var sel=0;
 var i=0;
 if(parent.nodeName=='SELECT'){
 for(;i<parent.options.length;i++){
 if(parent.options[i].selected)sel=i;
 var label=parent.options[i].innerHTML;
 var val=parent.options[i].getAttribute("value");
 if((typeof(val)=="undefined")||(val===null))val=label;
 x[i]=[val,label];
 }
}
if(str!=undefined)
{
 var Arr=str.split(m_dhtmlXListSplitStr);
 for(var j=0;j<Arr.length;j++){
 	var Arr1=Arr[j].split(m_dhtmlXValueSplitStr);
	var label=Arr1[1];
	var val=Arr1[0];
	if (Arr1.length>2){
		if (Arr1[2]=="1") {
			sel=i+j;
		}
	}
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i+j]=[val,label];
 }
}
 w.isD = parent.getAttribute("isDefualt");
 w.isP = parent.getAttribute("isPre");
 w._filttype = w.isP;
 w.addOption(x);
 if(w.isD=="true")
 {
   w.selectOption(sel);
   w.setComboText(w.optionsArr[sel].text)
 }
 parent.parentNode.removeChild(parent);
 
 return w;
}

function dhtmlXComboFromSelect(parent,str,size){
   if (typeof(parent)=="string")
      parent=document.getElementById(parent);

   size=size||parent.getAttribute("width")||(window.getComputedStyle?window.getComputedStyle(parent,null)["width"]:(parent.currentStyle?parent.currentStyle["width"]:0));
   if ((!size)||(size=="auto"))
   		size=parent.offsetWidth||100;

   var z=document.createElement("SPAN");
   parent.parentNode.insertBefore(z,parent);
   parent.style.display='none';

    var s_type = parent.getAttribute('opt_type');

   var w= new dhtmlXCombo(z,parent.name,size,s_type,parent.tabIndex);
   w.DOMelem_input.tabIndex=parent.tabIndex;
   w.DOMelem_input.name=parent.name;
   w.DOMelem_input.id=parent.id;
   w.tabIndex=parent.tabIndex;
   w.DOMelem_input.style.fontSize=parent.style.fontSize; 
   
   var x=new Array();
   var sel=0;
   var i=0;
 if(parent.nodeName=='SELECT'){
 for(var i=0;i<parent.options.length;i++){
 if(parent.options[i].selected)sel=i;
 var label=parent.options[i].innerHTML;
 var val=parent.options[i].getAttribute("value");
 if((typeof(val)=="undefined")||(val===null))val=label;
 x[i]=[val,label];
}
}
if(str!=undefined)
{
 var Arr=str.split(m_dhtmlXListSplitStr);
 for(var j=0;j<Arr.length;j++){
 	var Arr1=Arr[j].split(m_dhtmlXValueSplitStr);
	var label=Arr1[1];
	var val=Arr1[0];
	if (Arr1.length>2){
		if (Arr1[2]=="1") {
			sel=i+j;
		}
	}
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i+j]=[val,label];
 }
}
 w.isD = parent.getAttribute("isDefualt");
 w.isP = parent.getAttribute("isPre");
 w._filttype = w.isP;
 w.addOption(x);
 parent.parentNode.removeChild(parent);
if(w.isD=="true")
 {
   w.selectOption(sel);
   w.setComboText(w.optionsArr[sel].text)
 }
 return w;
}

var dhtmlXCombo_optionTypes = [];

function dhtmlXCombo(parent,name,width,optionType,tabIndex){
if (typeof(parent)=="string")
parent=document.getElementById(parent);
this.dhx_Event();
this.optionType = (optionType != window.undefined && dhtmlXCombo_optionTypes[optionType]) ? optionType : 'default';
this._optionObject = dhtmlXCombo_optionTypes[this.optionType];
this._disabled = false;
this._XmlTag="";
this._type="dhtmlXCombo";
this.type=this._type;
this._filttype = "false";
this.isD="false";
this.isP="false";
this.selectHandle = function(){return ;}
this.selectlistchange = function(){return ;}
if (!window.dhx_glbSelectAr){
window.dhx_glbSelectAr=new Array();
window.dhx_openedSelect=null;
window.dhx_SelectId=1;
dhtmlxEvent(document.body,"click",this.closeAll);
dhtmlxEvent(document.body,"keydown",function(e){ try { if ((e||event).keyCode==9)  window.dhx_glbSelectAr[0].closeAll(); } catch(e) {} return true; } );
}

 if (parent.tagName=="SELECT")
 dhtmlXComboFromSelect(parent);
 else{
 this._createSelf(parent,name,width,tabIndex);
 dhx_glbSelectAr.push(this);
}

}

dhtmlXCombo.prototype.setXmlTag = function(val){
this._XmlTag=val;
}

 dhtmlXCombo.prototype.getXmlTag = function(){
return this._XmlTag;
}

dhtmlXCombo.prototype.getXmlString = function()
{
	if (this._XmlTag==""){
		return "";
	}
	var myxml;
	var myrtn=this.getSelectedValue();
	if (myrtn==""){
		return "";
	}
	myxml= "<" + this._XmlTag +">";
	myxml = myxml+ myrtn.split("^")[0];
	myxml = myxml +"</" + this._XmlTag +">";
	return myxml;
	return;
}


 dhtmlXCombo.prototype.setSize = function(new_size){
  this.DOMlist.style.width=new_size+"px";
  if (this.DOMlistF) this.DOMlistF.style.width=new_size+"px";
  this.DOMelem.style.width=new_size+"px";
  this.DOMelem_input.style.width = (new_size-19)+'px';
 }      

 dhtmlXCombo.prototype.enableFilteringMode = function(mode,url,cache,autosubload){
  this._filter=convertStringToBoolean(mode);
  if (url){
  this._xml=url;
  this._autoxml=convertStringToBoolean(autosubload);
  }
  if (convertStringToBoolean(cache)) this._xmlCache=[];
  //this.DOMelem_button.style.display=(this._filter?"none":"");
 }
   
 dhtmlXCombo.prototype.setFilteringParam=function(name,value){
  if (!this._prs) this._prs=[];
  this._prs.push([name,value]);
 }

 dhtmlXCombo.prototype.disable = function(mode){
   var z=convertStringToBoolean(mode);
   if (this._disabled==z) return;
   this.DOMelem_input.disabled=z;
   this._disabled=z;
  }

  dhtmlXCombo.prototype.readonly = function(mode){
    this.DOMelem_input.readOnly=mode ? true : false;
   }

 dhtmlXCombo.prototype.getOption = function(value){
    for(var i=0; i<this.optionsArr.length; i++)
    if(this.optionsArr[i].value==value)
    return this.optionsArr[i];
    return null;
  }

  dhtmlXCombo.prototype.getOptionByLabel = function(value){
   for(var i=0; i<this.optionsArr.length; i++)
   if(this.optionsArr[i].text==value)
   return this.optionsArr[i];
   return null;
  }

  dhtmlXCombo.prototype.getOptionByIndex = function(ind){
   return this.optionsArr[ind];
   }

  dhtmlXCombo.prototype.clearAll = function(all){
	 if (all) this.setComboText("");   	  
    this.optionsArr=new Array();
    this.redrawOptions();
    if (all) this._confirmSelection();
   }

   dhtmlXCombo.prototype.deleteOption = function(value)
   {
      var ind=this.getIndexByValue(value);
      if(ind<0) return;                            
      if (this.optionsArr[ind]==this._selOption) this._selOption=null;
      this.optionsArr.splice(ind, 1);
      this.redrawOptions();
   }


   dhtmlXCombo.prototype.render=function(mode){
      this._skiprender=(!convertStringToBoolean(mode));
      this.redrawOptions();
   }


   dhtmlXCombo.prototype.updateOption = function(oldvalue, avalue, atext, acss)
   {
      var dOpt=this.getOption(oldvalue);
      if (typeof(avalue)!="object") avalue={text:atext,value:avalue,css:acss};
      dOpt.setValue(avalue);
        this.redrawOptions();
   }
   
dhtmlXCombo.prototype.addOptionStr = function(str)
 {
 this.clearAll();
 var x=new Array();
 var sel=0;
 var Arr=str.split(m_dhtmlXListSplitStr);
 for(var i=0;i<Arr.length;i++){
 	var Arr1=Arr[i].split(m_dhtmlXValueSplitStr);
	var label=Arr1[1];
	var val=Arr1[0];
	if (Arr1.length>2){
		if (Arr1[2]=="1") {
			sel=i;
		}
	}
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i]=[val,label];
 }
 this.addOption(x);
 if(this.isD=="true"){
   this.selectOption(sel);
   this.setComboText(this.optionsArr[sel].text)
 }
}

dhtmlXCombo.prototype.addOption = function(options)
{
 if(!arguments[0].length)
 args = [arguments];
 else
 args = options;
 this.render(false);
 for(var i=0;i<args.length;i++){
 var attr = args[i];
 var valueS ;
 if(attr.length){
 attr.value = attr[0]||"";
 attr.text = attr[1]||"";
 attr.index = "";
 if(attr[1]){
 //valueS=attr[1]||"";
 valueS=attr[1].split("-");
 if(this._filttype=="true") {
  valueS.reverse();
  attr.text=valueS.shift(); 
  valueS.reverse();
  attr.index=valueS.join("-");
 }
 else {
  attr.text = valueS.shift();
  attr.index = valueS.join("-");
  }
 }
 attr.css = attr[2]||"";
}
 this._addOption(attr);
}

 this.render(true);
}

 dhtmlXCombo.prototype._addOption = function(attr) {
  dOpt = new this._optionObject();
  this.optionsArr.push(dOpt);
  dOpt.setValue.apply(dOpt,[attr]);
  this.redrawOptions();
  }

dhtmlXCombo.prototype.getIndexByValue = function(val){
 for(var i=0; i<this.optionsArr.length; i++)
 if(this.optionsArr[i].value == val) return i;
 return -1;
 }


   dhtmlXCombo.prototype.getSelectedValue = function(){
      return (this._selOption?this._selOption.value:"");
   }

   dhtmlXCombo.prototype.getComboText = function(){
      return this.DOMelem_input.value;
   }

   dhtmlXCombo.prototype.setComboText = function(text){
 	if(text=="")
 {
   this.DOMelem_input.value="";
   this.DOMelem_hidden_input.value = "";
   this.unSelectOption();
 }
 
 else
 {
  this.DOMelem_input.value=text;
  for(var i=0; i<this.optionsArr.length; i++)
  	if (this.optionsArr[i].data()[1]==text)
     {
       this.selectOption(i);
       break;
     }
  }
 }
   

   dhtmlXCombo.prototype.setComboValue = function(text){
      var FindValueFlag=false;
      //this.setComboText(text);
      var myary=text.split("^");
      for(var i=0; i<this.optionsArr.length; i++){
      if(this.optionsArr[i].data()[0].length==0) continue;
        if (this.optionsArr[i].data()[0].split("^")[0]==myary[0])
         {
            this.selectOption(i);
            this.DOMelem_hidden_input.value = text;
            this._displayText();
            FindValueFlag=true;
            break;
         }
      }

      if ((text=="")&&(FindValueFlag==false)) {
        this.DOMelem_input.value="";
        this.DOMelem_hidden_input.value = "";
        this.unSelectOption();
      }
   }   


   dhtmlXCombo.prototype.getActualValue = function(){
      return this.DOMelem_hidden_input.value;
   }

   dhtmlXCombo.prototype.getSelectedText = function(){
      return (this._selOption?this._selOption.text:"");
   }

   dhtmlXCombo.prototype.getSelectedIndex = function(){
      for(var i=0; i<this.optionsArr.length; i++)
         if(this.optionsArr[i] == this._selOption) return i;
      return -1;
   }

   dhtmlXCombo.prototype.setName = function(name){
      this.DOMforSbm.name = name;
      this.name = name;
   }

   dhtmlXCombo.prototype.show = function(mode){
      if (convertStringToBoolean(mode))
         this.DOMelem.style.display = "";
      else
         this.DOMelem.style.display = "none";
   }


   dhtmlXCombo.prototype.destructor = function()
   {
      var _sID = this._inID;
      this.DOMParent.removeChild(this.DOMelem);
      this.DOMlist.parentNode.removeChild(this.DOMlist);
      var s=dhx_glbSelectAr;
      this.DOMParent=this.DOMlist=this.DOMelem=0;
      this.DOMlist.combo=this.DOMelem.combo=0;
      for(var i=0; i<s.length; i++)
      {
         if(s[i]._inID == _sID)
         {
            this._selectsArr[i] = null;
            this._selectsArr.splice(i,1);
            return;
         }
      }
   }


      dhtmlXCombo.prototype._createSelf = function(selParent, name, width, tab)
      {
         if (width.toString().indexOf("%")!=-1){ 
            var self = this;
            var resWidht=parseInt(width)/100;
            window.setInterval(function(){ 
               var ts=selParent.parentNode.offsetWidth*resWidht-2;
               if (ts==self._lastTs) return;
               self.setSize(self._lastTs=ts);},500);
            width=parseInt(selParent.offsetWidth);
         }

         width=parseInt(width||100);
         this.ListPosition = "Bottom"; //set optionlist positioning
         this.DOMParent = selParent;
         this._inID = null;
         this.name = name;

         this._selOption = null; //selected option object pointer
         this.optionsArr = Array();

            var opt = new this._optionObject();
            opt.DrawHeader(this,name, width,tab);
         //HTML select part 2 - options list DIV element
         this.DOMlist = document.createElement("DIV");
         this.DOMlist.className = 'dhx_combo_list';
         this.DOMlist.style.width=width-(_isIE?0:0)+"px";
		 if (_isOpera || _isKHTML ) 
		 		this.DOMlist.style.overflow="auto";      
         this.DOMlist.style.display = "none";
         document.body.insertBefore(this.DOMlist,document.body.firstChild);         
         if (_isIE)    {
            this.DOMlistF = document.createElement("IFRAME");
            this.DOMlistF.style.border="0px";
            this.DOMlistF.className = 'dhx_combo_list';
            this.DOMlistF.style.width=width-(_isIE?0:0)+"px";
            this.DOMlistF.style.display = "none";
            this.DOMlistF.src="javascript:false;"; 
            document.body.insertBefore(this.DOMlistF,document.body.firstChild);
            }
         this.DOMlist.combo=this.DOMelem.combo=this;
         this.DOMelem_input.onfocus=this._onFocus;
         this.DOMelem_input.onkeydown = this._onKey;
         this.DOMelem_input.onkeypress = this._onKeyF;
         this.DOMelem_input.onblur = this._onBlur;
         this.DOMelem.onclick = this._toggleSelect;
         this.DOMlist.onclick = this._selectOption;
         this.DOMlist.onmouseover = this._listOver;
         this.DOMlist.onkeydown = function(e){
         this.combo.DOMelem_input.focus();
          (e||event).cancelBubble=true;
         	this.combo.DOMelem_input.onkeydown(e)
     	 }
     	 
      }
      dhtmlXCombo.prototype.setfocus = function(e){
	     this.DOMelem_input.focus();
      }
      dhtmlXCombo.prototype._listOver = function(e)
      {
         e = e||event;
         e.cancelBubble = true;
         var node = (_isIE?event.srcElement:e.target);
         var that = this.combo;
         if ( node.parentNode == that.DOMlist ) {
            that.unSelectOption();
            var i=0;
            for (i; i<that.DOMlist.childNodes.length; i++) {
               if (that.DOMlist.childNodes[i]==node) break;
            }
            var z=that.optionsArr[i];
            that._selOption=z;
            that._selOption.select();
            
			if ((that._autoxml)&&((i+1)==that._lastLength))
            	that._fetchOptions(i+1,that._lasttext||"");            
         }

      }


      dhtmlXCombo.prototype._positList = function()
      {
         var pos=this.getPosition(this.DOMelem);
         if(this.ListPosition == 'Bottom'){
            this.DOMlist.style.top = pos[1]+this.DOMelem.offsetHeight+"px";
            this.DOMlist.style.left = pos[0]+"px";
         }
         else{
            this.DOMlist.style.top = pos[1]+"px";
            this.DOMlist.style.left = pos[0]+this.DOMelem.offsetWidth+"px";
         }
     
      }
      dhtmlXCombo.prototype.getPosition = function(oNode,pNode){

                  if(!pNode)
                        var pNode = document.body

                  var oCurrentNode=oNode;
                  var iLeft=0;
                  var iTop=0;
                  while ((oCurrentNode)&&(oCurrentNode!=pNode)){//.tagName!="BODY"){
               iLeft+=oCurrentNode.offsetLeft-oCurrentNode.scrollLeft;
               iTop+=oCurrentNode.offsetTop-oCurrentNode.scrollTop;
               oCurrentNode=oCurrentNode.offsetParent;//isIE()?:oCurrentNode.parentNode;
                  }
              if (pNode == document.body ){
                 if (_isIE){
                 if (document.documentElement.scrollTop)
                  iTop+=document.documentElement.scrollTop;
                 if (document.documentElement.scrollLeft)
                  iLeft+=document.documentElement.scrollLeft;
                  }
                  else
                       if (!_isFF){
                           iLeft+=document.body.offsetLeft;
                           iTop+=document.body.offsetTop;
                  }
                 }
                     return new Array(iLeft,iTop);
               }

      dhtmlXCombo.prototype._correctSelection = function(){
		 if (this.getComboText()!="")
         for (var i=0; i<this.optionsArr.length; i++)
            if (!this.optionsArr[i].isHidden()){
               return this.selectOption(i,true);
           }
         this.unSelectOption();
      }

      dhtmlXCombo.prototype.selectNext = function(step){
         if (this.DOMlist.style.display!="block")
      	 this.openSelect();
         var z=this.getSelectedIndex()+step;
         while (this.optionsArr[z]){
            if (!this.optionsArr[z].isHidden())
               return this.selectOption(z);
            z+=step;
         }
      }
      
 dhtmlXCombo.prototype._onFocus = function()
 {
   var that=this.parentNode.combo;
   dhtmlXRange(that.DOMelem_input,0,that.DOMelem_input.value.length);
 }

      dhtmlXCombo.prototype._onKeyF = function(e){
         var that=this.parentNode.combo;
         var ev=e||event;
         ev.cancelBubble=true;

         if (ev.keyCode=="13" || ev.keyCode=="9" || ev.keyCode=='32'){ //modify by zhouzq 2010.09.08 add space key process
         	
         	that._confirmSelection();
         	that.closeAll();
     	}
         if (ev.keyCode=="27" ){
         	that._resetSelection();
         	that.closeAll();
     	}

         if (ev.keyCode=="13" || ev.keyCode=="27" || ev.keyCode=='32'){ //modify by zhouzq 2010.09.08 add space key process
            that.callEvent("onKeyPressed",[ev.keyCode])
            return false;
         }
         return true;
      }

      dhtmlXCombo.prototype._onKey = function(e){
         var that=this.parentNode.combo;
       
         var ev=(e||event).keyCode;
            
        if (ev==27||ev==118||ev==119||ev==120||ev==121||ev==122||ev==123) return;
         // (e||event).cancelBubble=true;
        //if ((that.DOMlist.style.display!="block")&&(ev!="13")&&(ev!="9")&&((!that._filter)||(that._filterAny)))
            if ((that.DOMlist.style.display!="block")&&(ev!="13")&&(ev!="9")&&((!that._filter)||(that._filterAny)))
            that.DOMelem.onclick(e||event);
    //if ((ev=="13")&&(that.DOMlist.style.display=="none")){
    	  //that.callEvent("onKeyEnter",[ev.keyCode])
    	  //that.keyenterHandle();
    //}     
			if ((ev!="13")&&(ev!="9")&&((ev!="32")))//modify by zhouzq 2010.09.08 add space key process
         	window.setTimeout(function(){ that._onKeyB(ev); },1);
      }
      dhtmlXCombo.prototype._onKeyB = function(ev)
      {
         if (ev=="40"){  //down
            var z=this.selectNext(1);
         } else if (ev=="38"){ //up
            this.selectNext(-1);
         } else{
            this.callEvent("onKeyPressed",[ev])
         if(ev=="13"||ev=="9") 
           return;
          if (this._filter) return this.filterSelf((ev==8)||(ev==46));
            for(var i=0; i<this.optionsArr.length; i++)
               if (this.optionsArr[i].data()[1]==this.DOMelem_input.value){
                  ev.cancelBubble=true;
                  this.selectOption(i);
                  return false;
                  }
            this.unSelectOption();
         }
         return true;
      }

dhtmlXCombo.prototype._putattr=function(ary)
{
 this.clearAll();
 var x=new Array();
 var sel=0;
 var Arr=ary.split(m_dhtmlXListSplitStr);
 for(var i=0;i<Arr.length;i++){
 	var Arr1=Arr[i].split(m_dhtmlXValueSplitStr);
	var label=Arr1[1];
	var val=Arr1[0];
	if (Arr1.length>2){
		if (Arr1[2]=="1") {
			sel=i;
		}
	}
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i]=[val,label];
 }
 
 this.addOption(x);
 ///this.selectOption(sel);
 if(this.isD=="true"){
   this.selectOption(sel);
   this.setComboText(this.optionsArr[sel].text)
 }
	
}
 dhtmlXCombo.prototype._onBlur = function() {
  var self = this.parentNode._self;
	self._confirmSelection();        
  window.setTimeout(function(){
 	self.callEvent("onBlur",[]);
  },100)
 }
 dhtmlXCombo.prototype.redrawOptions = function(){
  if (this._skiprender) return;
   for(var i=this.DOMlist.childNodes.length-1; i>=0; i--){
   this.DOMlist.childNodes[i]._self=null;
   //purge(this.DOMlist.childNodes[i]);
   this.DOMlist.removeChild(this.DOMlist.childNodes[i]);
  }
   for(var i=0; i<this.optionsArr.length; i++)
   this.DOMlist.appendChild(this.optionsArr[i].render());  
   }

 dhtmlXCombo.prototype.loadXML = function(url,afterCall){
  this._load=true;
  if ((this._xmlCache)&&(this._xmlCache[url])){
  this._fillFromXML(this,null,null,null,this._xmlCache[url]);
  if (afterCall) afterCall();
   }
   else{
   var xml=(new dtmlXMLLoaderObject(this._fillFromXML,this,true,true));
   if (afterCall) xml.waitCall=afterCall;
   if (this._prs)
   for (var i=0; i<this._prs.length; i++)
   url+=[getUrlSymbol(url),escape(this._prs[i][0]),"=",escape(this._prs[i][1])].join("");
   xml._cPath=url;
   xml.loadXML(url);
   }
 }
 dhtmlXCombo.prototype.loadXMLString = function(astring){
  var xml=(new dtmlXMLLoaderObject(this._fillFromXML,this,true,true));
  xml.loadXMLString(astring);
 }
 dhtmlXCombo.prototype._fillFromXML = function(obj,b,c,d,xml){
   if (obj._xmlCache) obj._xmlCache[xml._cPath]=xml;
    //check that XML is correct 
   xml.getXMLTopNode("complete");
   var top=xml.doXPath("//complete");
   var options=xml.doXPath("//option");
   obj.render(false);
   if ((!top[0])||(!top[0].getAttribute("add"))){
   obj.clearAll();
   obj._lastLength=options.length;
	 if (obj._xml){
	 if ((!options) || (!options.length)) 
	 obj.closeAll();
	 else {
	 obj.DOMlist.style.display="block";
	 if (_isIE) obj._IEFix(true);
	  }}            
   } else
   obj._lastLength+=options.length;

   for (var i=0; i<options.length; i++) {
   var attr = new Object();
   attr.text = options[i].firstChild?options[i].firstChild.nodeValue:"";
   for (var j=0; j<options[i].attributes.length; j++) {
   var a = options[i].attributes[j];
   if (a)
   attr[a.nodeName] = a.nodeValue;
   }
   obj._addOption(attr);
   }
   obj.render(true);
  	
   if ((obj._load)&&(obj._load!==true))
   obj.loadXML(obj._load);
   else{
   obj._load=false;
   if ((!obj._lkmode)&&(!obj._filter))
   obj._correctSelection();
   }

   var selected=xml.doXPath("//option[@selected]");
   if (selected.length)
  	obj.selectOption(obj.getIndexByValue(selected[0].getAttribute("value")),false,true);

    }

      dhtmlXCombo.prototype.unSelectOption = function(){
         if (this._selOption)
            this._selOption.deselect();
         this._selOption=null;
      }
      
  dhtmlXCombo.prototype._confirmSelection = function(data,status){
  //if(arguments.length==0){
  //var z=this.getOptionByLabel(this.DOMelem_input.value);
  var z =  this._selOption;
 	data = z?z.value:"";
 	status = (z==null);
 	if (data==this.getActualValue()) return;
   //	}
          	
 	this.DOMelem_hidden_input.value=data;
  this.DOMelem_hidden_input2.value = (status?"true":"false");
 	this.callEvent("onChange",[]);

  if(typeof this.keyenterHandle == "function")
  this.keyenterHandle();
 	
  if(typeof this.selectHandle == "function")
  this.selectHandle();
  if (typeof this.selectlistchange == "function")
	this.selectlistchange();
  }
  dhtmlXCombo.prototype._resetSelection = function(data,status){
  	var z=this.getOption(this.DOMelem_hidden_input.value);
  	this.setComboValue(z?z.data()[0]:this.DOMelem_hidden_input.value)
    this.setComboText(z?z.data()[1]:this.DOMelem_hidden_input.value)
   }  	  
  	  

 dhtmlXCombo.prototype.selectOption = function(ind,filter,conf){
  this.unSelectOption();
  var z=this.optionsArr[ind];
  if (!z)  return;
  this._selOption=z;
  this._selOption.select();
  var corr=this._selOption.content.offsetTop+this._selOption.content.offsetHeight-this.DOMlist.scrollTop-this.DOMlist.offsetHeight;
  if (corr>0) this.DOMlist.scrollTop+=corr;
  corr=this.DOMlist.scrollTop-this._selOption.content.offsetTop;
  if (corr>0) this.DOMlist.scrollTop-=corr;
  var data=this._selOption.data();

	if (conf)
	this._confirmSelection(data[0],false);
	 	 
  if ((this._autoxml)&&((ind+1)==this._lastLength))
  this._fetchOptions(ind+1,this._lasttext||"");

  if (filter){
  var text=this.getComboText();
  //if (text!=data[1]){
  // this.setComboText(data[1]);
  //dhtmlXRange(this.DOMelem_input,text.length+1,data[1].length);
  }
  //}
  //else
  //   this.setComboText(data[1]);
  this._selOption.RedrawHeader(this);

  /*Event*/
  this.callEvent("onSelectionChange",[]);
  }

  dhtmlXCombo.prototype._selectOption = function(e) {
   (e||event).cancelBubble = true;
    var node=(_isIE?event.srcElement:e.target);
    var that=this.combo;
    while (!node._self) {
    node = node.parentNode;
    if (!node)
    return;
  }

  var i=0;
  for (i; i<that.DOMlist.childNodes.length; i++) {
  if (that.DOMlist.childNodes[i]==node) break;
  }
  that.selectOption(i,false,true);
  that.closeAll();
  }

   dhtmlXCombo.prototype.openSelect = function(){ 
      if (this._disabled) return;
      this.closeAll();
      this._positList();
      this.DOMlist.style.display="block";
            
        if (this.autoOptionSize){
        	var x=this.DOMlist.offsetWidth; 
        	for ( var i=0; i<this.optionsArr.length; i++)
        		if (this.DOMlist.childNodes[i].scrollWidth > x)
        			x=this.DOMlist.childNodes[i].scrollWidth;
        			
			this.DOMlist.style.width=x+"px";
		}
		      
      if (_isIE) this._IEFix(true);
      this.DOMelem_input.focus();

        // if (this._filter) this.filterSelf();
   }

   dhtmlXCombo.prototype._toggleSelect = function(e)
   {
      var that=this.combo;
     if (this.combo.getComboText()==""){
	      this.combo.filterSelf(true);
	 }
	 that.openSelect();
      /*if ( that.DOMlist.style.display == "block" ) {
        that.closeAll();
      } else {
         that.openSelect();
      }*/
      (e||event).cancelBubble = true;
   }

    dhtmlXCombo.prototype._fetchOptions=function(ind,text){
          if (text=="") { this.closeAll();  return this.clearAll();   }
         var url=this._xml+((this._xml.indexOf("?")!=-1)?"&":"?")+"pos="+ind+"&mask="+encodeURI(text);
         this._lasttext=text;
         if (this._load) this._load=url;
         else this.loadXML(url);
    }

    dhtmlXCombo.prototype.filterSelf = function(mode)
   {
      var text=this.getComboText();
      if(text==" ")
      { 
       text="";
       this.setComboText("");
      }
      if (this._xml){
         this._lkmode=mode;
         this._fetchOptions(0,text);
      }
       var textbegin = text.indexOf("-");
       var textend = text.length;
       text = text.substring(textbegin+1,textend);
       var filterString = "(^"+text+")|(-"+text+")";
      try{ var filter=new RegExp(filterString,"i"); } catch (e){ var filter=new RegExp(filterString.replace(/([\[\]\{\}\(\)\+\*\\])/g,"\\$1")); }
      
      this.filterAny=false;
      for(var i=0; i<this.optionsArr.length; i++){
      	 var z=filter.test(this.optionsArr[i].index);
      	 this.filterAny|=z;
         this.optionsArr[i].hide(!z);
      }
      if (!this.filterAny) {
		this.closeAll();
		this.setComboText("");
        this.value="";
	  }
      else {
      	  if (this.DOMlist.style.display!="block")
      	   		this.openSelect();
	      if (_isIE) this._IEFix(true);
  		}
         
        if (!mode)
         this._correctSelection();   
        else this.unSelectOption();
   }



   dhtmlXCombo.prototype._IEFix = function(mode){
      this.DOMlistF.style.display=(mode?"block":"none");
        this.DOMlistF.style.top=this.DOMlist.style.top;
        this.DOMlistF.style.left=this.DOMlist.style.left;
   }

 dhtmlXCombo.prototype.closeAll = function()
 {
 if(window.dhx_glbSelectAr)
 for(var i=0;i<dhx_glbSelectAr.length;i++)
 if(dhx_glbSelectAr[i].DOMlist.style.display=="block"){
 dhx_glbSelectAr[i]._displayText();
 dhx_glbSelectAr[i].DOMlist.style.display = "none";
 if(_isIE)dhx_glbSelectAr[i]._IEFix(false);
 }
}
   
dhtmlXCombo.prototype._displayText=function()
 {

   if(this._selOption==null)
       {
         this.setComboText("");
         this.value="";
       }  
       else
       {
         this.setComboText( this._selOption.data()[1]);
         this.value=this._selOption==null?"":this._selOption.data()[0];
        
       }
 }

function dhtmlXRange(InputId, Start, End)
{
   var Input = typeof(InputId)=='object' ? InputId : document.getElementById(InputId);
   try{    Input.focus();   } catch(e){};
   var Length = Input.value.length;
   Start--;
   if (Start < 0 || Start > End || Start > Length)
      Start = 0;
   if (End > Length)
      End = Length;
   if (Input.setSelectionRange) {
      Input.setSelectionRange(Start, End);
   } else if (Input.createTextRange) {
      var range = Input.createTextRange();
      range.moveStart('character', Start);
      range.moveEnd('character', End-Length);
      range.select();
   }
}

      dhtmlXCombo_defaultOption = function(){
         this.init();
      }

      dhtmlXCombo_defaultOption.prototype.init = function(){
         this.value = null;
         this.text = "";
         this.selected = false;
         this.css = "";
      }

      dhtmlXCombo_defaultOption.prototype.select = function(){
         if (this.content) ;
            this.content.className="dhx_selected_option";
      }

      dhtmlXCombo_defaultOption.prototype.hide = function(mode){
         this.render().style.display=mode?"none":"";
      }

      dhtmlXCombo_defaultOption.prototype.isHidden = function(){
         return (this.render().style.display=="none");
      }

      dhtmlXCombo_defaultOption.prototype.deselect = function(){
         if (this.content) this.render();
            this.content.className="";
      }

dhtmlXCombo_defaultOption.prototype.setValue = function(attr){
  this.value = attr.value||"";
 this.text = attr.text||"";
 this.index = attr.index||"";
 this.css = attr.css||"";
 this.content=null;
}

dhtmlXCombo_defaultOption.prototype.render = function(){
  if (!this.content){
  this.content=document.createElement("DIV");
  this.content._self = this;
  this.content.style.cssText='width:100%; overflow:hidden; "+this.css+"';
  if (_isOpera || _isKHTML ) this.content.style.padding="2px 0px 2px 0px";
  this.content.innerHTML=this.text+"&nbsp;&nbsp;"+this.index;
  this._ctext=_isIE?this.content.innerText:this.content.textContent;
  }
   return this.content;
  }
  
  dhtmlXCombo_defaultOption.prototype.data = function(){
   if (this.content)
   return [this.value,this.text,this.index];
  }

dhtmlXCombo_defaultOption.prototype.DrawHeader = function(self, name, width, tab)
{
    var z=document.createElement("DIV");
    z.style.width = width+"px";
    z.className = 'dhx_combo_box';
    z._self = self;
   self.DOMelem = z;
    this._DrawHeaderInput(self, name, width,tab);
   this._DrawHeaderButton(self, name, width);
    self.DOMParent.appendChild(self.DOMelem);
}

dhtmlXCombo_defaultOption.prototype._DrawHeaderInput = function(self, name, width,tab)
{
   var z=document.createElement('input');
   z.className = 'dhx_combo_input';
   z.type = 'text';
   z.name = name;
   if (tab) z.tabIndex=tab;
   z.style.width = (width-19)+'px';
   self.DOMelem.appendChild(z);
   self.DOMelem_input = z;

   z = document.createElement('input');
   z.type = 'hidden';
   z.name ="form"+name;
   self.DOMelem.appendChild(z);
   self.DOMelem_hidden_input = z;

   z = document.createElement('input');
   z.type = 'hidden';
   z.name = name+"_new_value";
   z.value="true";
   self.DOMelem.appendChild(z);
   self.DOMelem_hidden_input2 = z;
}

dhtmlXCombo_defaultOption.prototype._DrawHeaderButton = function(self, name, width)
{
   var z=document.createElement('img');
   z.className = 'dhx_combo_img';
   z.src = (window.dhx_globalImgPath?dhx_globalImgPath:"")+'combo_select.gif';
   self.DOMelem.appendChild(z);
   self.DOMelem_button=z;
}

dhtmlXCombo_defaultOption.prototype.RedrawHeader = function(self)
{
}


dhtmlXCombo_optionTypes['default'] = dhtmlXCombo_defaultOption;

dhtmlXCombo.prototype.dhx_Event=function()
{
   this.dhx_SeverCatcherPath="";

   this.attachEvent = function(original, catcher, CallObj)
   {
      CallObj = CallObj||this;
      original = 'ev_'+original;
       if ( ( !this[original] ) || ( !this[original].addEvent ) ) {
           var z = new this.eventCatcher(CallObj);
           z.addEvent( this[original] );
           this[original] = z;
       }
       return ( original + ':' + this[original].addEvent(catcher) );   //return ID (event name & event ID)
   }
   this.callEvent=function(name,arg0){
         if (this["ev_"+name]) return this["ev_"+name].apply(this,arg0);
       return true;
   }
   this.checkEvent=function(name){
         if (this["ev_"+name]) return true;
       return false;
   }

   this.eventCatcher = function(obj)
   {
       var dhx_catch = new Array();
       var m_obj = obj;
       var func_server = function(catcher,rpc)
                         {
                           catcher = catcher.split(":");
                     var postVar="";
                     var postVar2="";
                           var target=catcher[1];
                     if (catcher[1]=="rpc"){
                           postVar='<?xml version="1.0"?><methodCall><methodName>'+catcher[2]+'</methodName><params>';
                        postVar2="</params></methodCall>";
                        target=rpc;
                     }
                           var z = function() {
                                   }
                           return z;
                         }
       var z = function()
             {
                   if (dhx_catch)
                      var res=true;
                   for (var i=0; i<dhx_catch.length; i++) {
                      if (dhx_catch[i] != null) {
                           var zr = dhx_catch[i].apply( m_obj, arguments );
                           res = res && zr;
                      }
                   }
                   return res;
                }
       z.addEvent = function(ev)
                {
                       if ( typeof(ev) != "function" )
                           if (ev && ev.indexOf && ev.indexOf("server:") == 0)
                               ev = new func_server(ev,m_obj.rpcServer);
                           else
                               ev = eval(ev);
                       if (ev)
                           return dhx_catch.push( ev ) - 1;
                       return false;
                }
       z.removeEvent = function(id)
                   {
                     dhx_catch[id] = null;
                   }
       return z;
   }

   this.detachEvent = function(id)
   {
      if (id != false) {
         var list = id.split(':');           
         this[ list[0] ].removeEvent( list[1] );   
      }
   }
}


 function purge(d) {

  var a = d.attributes, i, l, n;
  if (a) {
      l = a.length;
      for (i = 0; i < l; i += 1) {
          n = a[i].name;
          if (typeof d[n] === 'function') {
              d[n] = null;
          }
      }
   
       d["_self"]=null;
  }
  /*
  a = d.childNodes;
  if (a) {
      l = a.length;
      for (i = 0; i < l; i += 1) {
          purge(d.childNodes[i]);
      }
  }
  */
  
}