var DHCMedTreeConfig = {
	rootIcon        : '../scripts/dhcmedimages/foldericon.png',
	openRootIcon    : '../scripts/dhcmedimages/openfoldericon.png',
	folderIcon      : '../scripts/dhcmedimages/foldericon.png',
	openFolderIcon  : '../scripts/dhcmedimages/openfoldericon.png',
	fileIcon        : '../scripts/dhcmedimages/file.png',
	iIcon           : '../scripts/dhcmedimages/I.png',
	lIcon           : '../scripts/dhcmedimages/L.png',
	lMinusIcon      : '../scripts/dhcmedimages/Lminus.png',
	lPlusIcon       : '../scripts/dhcmedimages/Lplus.png',
	tIcon           : '../scripts/dhcmedimages/T.png',
	tMinusIcon      : '../scripts/dhcmedimages/Tminus.png',
	tPlusIcon       : '../scripts/dhcmedimages/Tplus.png',
	blankIcon       : '../scripts/dhcmedimages/blank.png',
	defaultText     : 'Tree Item',
	defaultAction   : 'javascript:void(0);',
	defaultBehavior : 'classic',
	usePersistence	: true
};

var DHCMedTreeHandler = {
	idCounter : 0,
	idPrefix  : "dhcmed-tree-object-",
	all       : {},
	behavior  : null,
	selected  : null,
	onSelect  : null, /* should be part of tree, not handler */
	getId     : function() { return this.idPrefix + this.idCounter++; },
	toggle    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggle(); },
	select    : function (oItem) { this.all[oItem.id.replace('-icon','')].select(); },
	focus     : function (oItem) { this.all[oItem.id.replace('-anchor','')].focus(); },
	blur      : function (oItem) { this.all[oItem.id.replace('-anchor','')].blur(); },
	keydown   : function (oItem, e) { return this.all[oItem.id].keydown(e.keyCode); },
	cookies   : new DHCMedCookie(),
	insertHTMLBeforeEnd	:	function (oElement, sHTML) {
		if (oElement.insertAdjacentHTML != null) {
			oElement.insertAdjacentHTML("BeforeEnd", sHTML)
			return;
		}
		var df;	// DocumentFragment
		var r = oElement.ownerDocument.createRange();
		r.selectNodeContents(oElement);
		r.collapse(false);
		df = r.createContextualFragment(sHTML);
		oElement.appendChild(df);
	}
};

/*
 * DHCMedCookie class
 */

function DHCMedCookie() {
	if (document.cookie.length) { this.cookies = ' ' + document.cookie; }
}

DHCMedCookie.prototype.setCookie = function (key, value) {
	document.cookie = key + "=" + escape(value);
}

DHCMedCookie.prototype.getCookie = function (key) {
	if (this.cookies) {
		var start = this.cookies.indexOf(' ' + key + '=');
		if (start == -1) { return null; }
		var end = this.cookies.indexOf(";", start);
		if (end == -1) { end = this.cookies.length; }
		end -= start;
		var cookie = this.cookies.substr(start,end);
		return unescape(cookie.substr(cookie.indexOf('=') + 1, cookie.length - cookie.indexOf('=') + 1));
	}
	else { return null; }
}

/*
 * DHCMedTreeAbstractNode class
 */

function DHCMedTreeAbstractNode(sText, sRowid , sAction) {
	this.childNodes  = [];
	this.id     = DHCMedTreeHandler.getId();
	this.rowid  = sRowid || "999999";
	this.text   = sText || DHCMedTreeConfig.defaultText;
	this.action = sAction || DHCMedTreeConfig.defaultAction;
	this._last  = false;
	DHCMedTreeHandler.all[this.id] = this;
}

DHCMedTreeAbstractNode.prototype.setRowid = function (sRowid) {
	this.Rowid=sRowid;
}

/*
 * To speed thing up if you're adding multiple nodes at once (after load)
 * use the bNoIdent parameter to prevent automatic re-indentation and call
 * the obj.ident() method manually once all nodes has been added.
 */

DHCMedTreeAbstractNode.prototype.add = function (node, bNoIdent) {
	node.parentNode = this;
	this.childNodes[this.childNodes.length] = node;
	var root = this;
	if (this.childNodes.length >= 2) {
		this.childNodes[this.childNodes.length - 2]._last = false;
	}
	while (root.parentNode) { root = root.parentNode; }
	if (root.rendered) {
		if (this.childNodes.length >= 2) {
			document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-plus').src = ((this.childNodes[this.childNodes.length -2].folder)?((this.childNodes[this.childNodes.length -2].open)?DHCMedTreeConfig.tMinusIcon:DHCMedTreeConfig.tPlusIcon):DHCMedTreeConfig.tIcon);
			this.childNodes[this.childNodes.length - 2].plusIcon = DHCMedTreeConfig.tPlusIcon;
			this.childNodes[this.childNodes.length - 2].minusIcon = DHCMedTreeConfig.tMinusIcon;
			this.childNodes[this.childNodes.length - 2]._last = false;
		}
		this._last = true;
		var foo = this;
		while (foo.parentNode) {
			for (var i = 0; i < foo.parentNode.childNodes.length; i++) {
				if (foo.id == foo.parentNode.childNodes[i].id) { break; }
			}
			if (i == foo.parentNode.childNodes.length - 1) { foo.parentNode._last = true; }
			else { foo.parentNode._last = false; }
			foo = foo.parentNode;
		}
		DHCMedTreeHandler.insertHTMLBeforeEnd(document.getElementById(this.id + '-cont'), node.toString());
		if ((!this.folder) && (!this.openIcon)) {
			this.icon = DHCMedTreeConfig.folderIcon;
			this.openIcon = DHCMedTreeConfig.openFolderIcon;
		}
		if (!this.folder) { this.folder = true; this.collapse(true); }
		if (!bNoIdent) { this.indent(); }
	}
	return node;
}

DHCMedTreeAbstractNode.prototype.toggle = function() {
	if (this.folder) {
		if (this.open) { this.collapse(); }
		else { this.expand(); }
}	}

DHCMedTreeAbstractNode.prototype.select = function() {
	document.getElementById(this.id + '-anchor').focus();
}

DHCMedTreeAbstractNode.prototype.deSelect = function() {
	document.getElementById(this.id + '-anchor').className = '';
	DHCMedTreeHandler.selected = null;
}

DHCMedTreeAbstractNode.prototype.focus = function() {
	if ((DHCMedTreeHandler.selected) && (DHCMedTreeHandler.selected != this)) { DHCMedTreeHandler.selected.deSelect(); }
	DHCMedTreeHandler.selected = this;
	if ((this.openIcon) && (DHCMedTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.openIcon; }
	document.getElementById(this.id + '-anchor').className = 'selected';
	document.getElementById(this.id + '-anchor').focus();
	if (DHCMedTreeHandler.onSelect) { DHCMedTreeHandler.onSelect(this); }
}

DHCMedTreeAbstractNode.prototype.blur = function() {
	if ((this.openIcon) && (DHCMedTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected-inactive';
}

DHCMedTreeAbstractNode.prototype.doExpand = function() {
	if (DHCMedTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.openIcon; }
	if (this.childNodes.length) {  document.getElementById(this.id + '-cont').style.display = 'block'; }
	this.open = true;
	if (DHCMedTreeConfig.usePersistence) {
		DHCMedTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '1');
}	}

DHCMedTreeAbstractNode.prototype.doCollapse = function() {
	if (DHCMedTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.icon; }
	if (this.childNodes.length) { document.getElementById(this.id + '-cont').style.display = 'none'; }
	this.open = false;
	if (DHCMedTreeConfig.usePersistence) {
		DHCMedTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '0');
}	}

DHCMedTreeAbstractNode.prototype.expandAll = function() {
	this.expandChildren();
	if ((this.folder) && (!this.open)) { this.expand(); }
}

DHCMedTreeAbstractNode.prototype.expandChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].expandAll();
} }

DHCMedTreeAbstractNode.prototype.collapseAll = function() {
	this.collapseChildren();
	if ((this.folder) && (this.open)) { this.collapse(true); }
}

DHCMedTreeAbstractNode.prototype.collapseChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].collapseAll();
} }

DHCMedTreeAbstractNode.prototype.indent = function(lvl, del, last, level, nodesLeft) {
	/*
	 * Since we only want to modify items one level below ourself,
	 * and since the rightmost indentation position is occupied by
	 * the plus icon we set this to -2
	 */
	if (lvl == null) { lvl = -2; }
	var state = 0;
	for (var i = this.childNodes.length - 1; i >= 0 ; i--) {
		state = this.childNodes[i].indent(lvl + 1, del, last, level);
		if (state) { return; }
	}
	if (del) {
		if ((level >= this._level) && (document.getElementById(this.id + '-plus'))) {
			if (this.folder) {
				document.getElementById(this.id + '-plus').src = (this.open)?DHCMedTreeConfig.lMinusIcon:DHCMedTreeConfig.lPlusIcon;
				this.plusIcon = DHCMedTreeConfig.lPlusIcon;
				this.minusIcon = DHCMedTreeConfig.lMinusIcon;
			}
			else if (nodesLeft) { document.getElementById(this.id + '-plus').src = DHCMedTreeConfig.lIcon; }
			return 1;
	}	}
	var foo = document.getElementById(this.id + '-indent-' + lvl);
	if (foo) {
		if ((foo._last) || ((del) && (last))) { foo.src =  DHCMedTreeConfig.blankIcon; }
		else { foo.src =  DHCMedTreeConfig.iIcon; }
	}
	return 0;
}

/*
 * DHCMedTree class
 */

function DHCMedTree(sText, sAction, sBehavior, sIcon, sOpenIcon) {
	this.base = DHCMedTreeAbstractNode;
	this.base(sText, sAction);
	this.icon      = sIcon || DHCMedTreeConfig.rootIcon;
	this.openIcon  = sOpenIcon || DHCMedTreeConfig.openRootIcon;
	/* Defaults to open */
	if (DHCMedTreeConfig.usePersistence) {
		this.open  = (DHCMedTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '0')?false:true;
	} else { this.open  = true; }
	this.folder    = true;
	this.rendered  = false;
	this.onSelect  = null;
	if (!DHCMedTreeHandler.behavior) {  DHCMedTreeHandler.behavior = sBehavior || DHCMedTreeConfig.defaultBehavior; }
}

DHCMedTree.prototype = new DHCMedTreeAbstractNode;

DHCMedTree.prototype.setBehavior = function (sBehavior) {
	DHCMedTreeHandler.behavior =  sBehavior;
};

DHCMedTree.prototype.getBehavior = function (sBehavior) {
	return DHCMedTreeHandler.behavior;
};

DHCMedTree.prototype.getSelected = function() {
	if (DHCMedTreeHandler.selected) { return DHCMedTreeHandler.selected; }
	else { return null; }
}

DHCMedTree.prototype.remove = function() { }

DHCMedTree.prototype.expand = function() {
	this.doExpand();
}

DHCMedTree.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
}

DHCMedTree.prototype.getFirst = function() {
	return null;
}

DHCMedTree.prototype.getLast = function() {
	return null;
}

DHCMedTree.prototype.getNextSibling = function() {
	return null;
}

DHCMedTree.prototype.getPreviousSibling = function() {
	return null;
}

DHCMedTree.prototype.keydown = function(key) {
	if (key == 39) {
		if (!this.open) { this.expand(); }
		else if (this.childNodes.length) { this.childNodes[0].select(); }
		return false;
	}
	if (key == 37) { this.collapse(); return false; }
	if ((key == 40) && (this.open) && (this.childNodes.length)) { this.childNodes[0].select(); return false; }
	return true;
}

DHCMedTree.prototype.toString = function() {
	var str = "<div id=\"" + this.id + "\" ondblclick=\"DHCMedTreeHandler.toggle(this);\" class=\"dhcmed-tree-item\" onkeydown=\"return DHCMedTreeHandler.keydown(this, event)\">" +
		"<img id=\"" + this.id + "-icon\" class=\"dhcmed-tree-icon\" src=\"" + ((DHCMedTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"DHCMedTreeHandler.select(this);\">" +
		"<a href='#'"
		+ "\" id=\"" + this.id + "-anchor\" onfocus=\"DHCMedTreeHandler.focus(this);\" onblur=\"DHCMedTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + this.text + "</a></div>" +
		"<div id=\"" + this.id + "-cont\" class=\"dhcmed-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	return str + sb.join("") + "</div>";
};

/*
 * DHCMedTreeItem class
 */

function DHCMedTreeItem(sText, sAction, eParent, sIcon, sOpenIcon) {
	this.base = DHCMedTreeAbstractNode;
	this.base(sText, sAction);
	/* Defaults to close */
	if (DHCMedTreeConfig.usePersistence) {
		this.open = (DHCMedTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '1')?true:false;
	} else { this.open = false; }
	if (sIcon) { this.icon = sIcon; }
	if (sOpenIcon) { this.openIcon = sOpenIcon; }
	if (eParent) { eParent.add(this); }
}

DHCMedTreeItem.prototype = new DHCMedTreeAbstractNode;

DHCMedTreeItem.prototype.remove = function() {
	var iconSrc = document.getElementById(this.id + '-plus').src;
	var parentNode = this.parentNode;
	var prevSibling = this.getPreviousSibling(true);
	var nextSibling = this.getNextSibling(true);
	var folder = this.parentNode.folder;
	var last = ((nextSibling) && (nextSibling.parentNode) && (nextSibling.parentNode.id == parentNode.id))?false:true;
	this.getPreviousSibling().focus();
	this._remove();
	if (parentNode.childNodes.length == 0) {
		document.getElementById(parentNode.id + '-cont').style.display = 'none';
		parentNode.doCollapse();
		parentNode.folder = false;
		parentNode.open = false;
	}
	if (!nextSibling || last) { parentNode.indent(null, true, last, this._level, parentNode.childNodes.length); }
	if ((prevSibling == parentNode) && !(parentNode.childNodes.length)) {
		prevSibling.folder = false;
		prevSibling.open = false;
		iconSrc = document.getElementById(prevSibling.id + '-plus').src;
		iconSrc = iconSrc.replace('minus', '').replace('plus', '');
		document.getElementById(prevSibling.id + '-plus').src = iconSrc;
		document.getElementById(prevSibling.id + '-icon').src = DHCMedTreeConfig.fileIcon;
	}
	if (document.getElementById(prevSibling.id + '-plus')) {
		if (parentNode == prevSibling.parentNode) {
			iconSrc = iconSrc.replace('minus', '').replace('plus', '');
			document.getElementById(prevSibling.id + '-plus').src = iconSrc;
}	}	}

DHCMedTreeItem.prototype._remove = function() {
	for (var i = this.childNodes.length - 1; i >= 0; i--) {
		this.childNodes[i]._remove();
 	}
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) {
			for (var j = i; j < this.parentNode.childNodes.length; j++) {
				this.parentNode.childNodes[j] = this.parentNode.childNodes[j+1];
			}
			this.parentNode.childNodes.length -= 1;
			if (i + 1 == this.parentNode.childNodes.length) { this.parentNode._last = true; }
			break;
	}	}
	DHCMedTreeHandler.all[this.id] = null;
	var tmp = document.getElementById(this.id);
	if (tmp) { tmp.parentNode.removeChild(tmp); }
	tmp = document.getElementById(this.id + '-cont');
	if (tmp) { tmp.parentNode.removeChild(tmp); }
}

DHCMedTreeItem.prototype.expand = function() {
	this.doExpand();
	document.getElementById(this.id + '-plus').src = this.minusIcon;
}

DHCMedTreeItem.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
	document.getElementById(this.id + '-plus').src = this.plusIcon;
}

DHCMedTreeItem.prototype.getFirst = function() {
	return this.childNodes[0];
}

DHCMedTreeItem.prototype.getLast = function() {
	if (this.childNodes[this.childNodes.length - 1].open) { return this.childNodes[this.childNodes.length - 1].getLast(); }
	else { return this.childNodes[this.childNodes.length - 1]; }
}

DHCMedTreeItem.prototype.getNextSibling = function() {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (++i == this.parentNode.childNodes.length) { return this.parentNode.getNextSibling(); }
	else { return this.parentNode.childNodes[i]; }
}

DHCMedTreeItem.prototype.getPreviousSibling = function(b) {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (i == 0) { return this.parentNode; }
	else {
		if ((this.parentNode.childNodes[--i].open) || (b && this.parentNode.childNodes[i].folder)) { return this.parentNode.childNodes[i].getLast(); }
		else { return this.parentNode.childNodes[i]; }
} }

DHCMedTreeItem.prototype.keydown = function(key) {
	if ((key == 39) && (this.folder)) {
		if (!this.open) { this.expand(); }
		else { this.getFirst().select(); }
		return false;
	}
	else if (key == 37) {
		if (this.open) { this.collapse(); }
		else { this.parentNode.select(); }
		return false;
	}
	else if (key == 40) {
		if (this.open) { this.getFirst().select(); }
		else {
			var sib = this.getNextSibling();
			if (sib) { sib.select(); }
		}
		return false;
	}
	else if (key == 38) { this.getPreviousSibling().select(); return false; }
	return true;
}

DHCMedTreeItem.prototype.toString = function (nItem, nItemCount) {
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = "<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + ((foo._last)?DHCMedTreeConfig.blankIcon:DHCMedTreeConfig.iIcon) + "\">" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else { this.open = false; }
	if ((this.folder) || (DHCMedTreeHandler.behavior != 'classic')) {
		if (!this.icon) { this.icon = DHCMedTreeConfig.folderIcon; }
		if (!this.openIcon) { this.openIcon = DHCMedTreeConfig.openFolderIcon; }
	}
	else if (!this.icon) { this.icon = DHCMedTreeConfig.fileIcon; }
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	var str = "<div id=\"" + this.id + "\" ondblclick=\"DHCMedTreeHandler.toggle(this);\" class=\"dhcmed-tree-item\" onkeydown=\"return DHCMedTreeHandler.keydown(this, event)\">" +
		indent +
		"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?DHCMedTreeConfig.lMinusIcon:DHCMedTreeConfig.tMinusIcon):((this.parentNode._last)?DHCMedTreeConfig.lPlusIcon:DHCMedTreeConfig.tPlusIcon)):((this.parentNode._last)?DHCMedTreeConfig.lIcon:DHCMedTreeConfig.tIcon)) + "\" onclick=\"DHCMedTreeHandler.toggle(this);\">" +
		"<img id=\"" + this.id + "-icon\" class=\"dhcmed-tree-icon\" src=\"" + ((DHCMedTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"DHCMedTreeHandler.select(this);\">" +
		"<a href='#'"
	if (!this.childNodes.length) str=str + "ondblclick=\"ReturnEntry('" + this.rowid + "','" + label +"')\";" 
	str=str + " id=\"" + this.id + "-anchor\" onfocus=\"DHCMedTreeHandler.focus(this);\" onblur=\"DHCMedTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + label + "</a></div>" +
		"<div id=\"" + this.id + "-cont\" class=\"dhcmed-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
	}
	this.plusIcon = ((this.parentNode._last)?DHCMedTreeConfig.lPlusIcon:DHCMedTreeConfig.tPlusIcon);
	this.minusIcon = ((this.parentNode._last)?DHCMedTreeConfig.lMinusIcon:DHCMedTreeConfig.tMinusIcon);
	return str + sb.join("") + "</div>";
}

//*************************add by zf 2009-03-10 start**********************************

function ReturnEntry(EntryID,EntryDesc)
{
	window.returnValue =EntryID+"^"+EntryDesc;
	window.close();
}

function GetRuleSection(rID,sRowid,JIndex)
{
	var strMethod = document.getElementById("MethodGetRuleSection").value;
	var ret = cspRunServerMethod(strMethod,rID,sRowid,JIndex);
	return ret;
}

function GetSectionEntry(sID,eRowid,JIndex)
{
	var strMethod = document.getElementById("MethodGetSectionEntry").value;
	var ret = cspRunServerMethod(strMethod,sID,eRowid,JIndex);
	return ret;
}

function GetEntryEntry(eID,eERowid,JIndex)
{
	var strMethod = document.getElementById("MethodGetEntryEntry").value;
	var ret = cspRunServerMethod(strMethod,eID,eERowid,JIndex);
	return ret;
}

function AddRSectionOBJ(rOBJ,rID,JIndex)
{
	var sRowid="";
	while(1)
	{
		var sDesc="",sID="";
		var tmpSection=GetRuleSection(rID,sRowid,JIndex);
		if (tmpSection=="") break;
		var tmpSectionL=tmpSection.split("^");
		if (tmpSectionL.length>=2)
		{
			var tmpSDicL=tmpSectionL[1].split("/");
			sDesc=tmpSDicL[2];
			sID=tmpSDicL[0];
			sRowid=tmpSectionL[0];
			var sOBJ = new DHCMedTreeItem(sDesc,sRowid);
			rOBJ.add(sOBJ);
			AddSEntryOBJ(sOBJ,sRowid,JIndex);
		}else{
			break;
		}
	}
}

function AddSEntryOBJ(sOBJ,sID,JIndex)
{
	var eRowid="";
	while(1)
	{
		var eDesc="",eID="";
		var tmpEntry=GetSectionEntry(sID,eRowid,JIndex);
		if (tmpEntry=="") break;
		var tmpEntryL=tmpEntry.split("^");
		if (tmpEntryL.length>=2)
		{
			var tmpEDicL=tmpEntryL[1].split("/");
			eDesc=tmpEDicL[2];
			eID=tmpEDicL[0];
			eRowid=tmpEntryL[0];
			var eOBJ = new DHCMedTreeItem(eDesc,eRowid);
			sOBJ.add(eOBJ);
			AddEEntryOBJ(eOBJ,eRowid,JIndex);
		}else{
			break;
		}
	}
}

function AddEEntryOBJ(eOBJ,eID,JIndex)
{
	var eERowid="";
	while(1)
	{
		var eEDesc="",eEID="";
		var tmpEEntry=GetEntryEntry(eID,eERowid,JIndex);
		if (tmpEEntry=="") break;
		var tmpEEntryL=tmpEEntry.split("^");
		if (tmpEEntryL.length>=2)
		{
			var tmpEDicL=tmpEEntryL[1].split("/");
			eEDesc=tmpEDicL[2];
			eEID=tmpEDicL[0];
			eRowid=tmpEDicL[0];
			var eEOBJ = new DHCMedTreeItem(eEDesc,eRowid);
			eOBJ.add(eEOBJ);
			AddEEntryOBJ(eEOBJ,eRowid,JIndex);
		}else{
			break;
		}
	}
}
//*************************add by zf 2009-03-10 end**********************************