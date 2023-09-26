//<!-- Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. -->
var av;
var imageViewer;
//alert(bStudy);
var LinkApp1=false;
var LinkApp2=false;
var LinkApp3=false;
var LinkApp4=false;
var toggleViewFlag=0;
var currSeriesLayout = 1;

var IMGPath="../images/webemr/";

var btnSeriesGrp = new ButtonGroup();
var btnImgGrp    = new ButtonGroup();
var btnToolsGrp  = new ButtonGroup();
var btnFitGrp    = new ButtonGroup();
var btnStopStart = new ButtonGroup();

var btnRulerToggle;
var btnAnglesToggle;
var btnAnnotationsToggle;

var btnInvertToggle;
var btnPreviewToggle;
var btnThumbToggle;
var btnSeriesStudyViewToggle;

ButtonGroup.prototype.buttonObj;
ButtonGroup.prototype.onState;
ButtonGroup.prototype.offState;

function ButtonGroup()
{
	this.buttonObj = new Array;
	this.onState = new Array;
	this.offState = new Array;
}
ButtonGroup.prototype.add = function(obj, onImg, offImg)
{
	var index = this.buttonObj.length;
	this.buttonObj[index]=obj;
	this.onState[index]=onImg;
	this.offState[index]=offImg;
}
ButtonGroup.prototype.get =function()
{
	for(var i = 0;i<this.buttonObj.length;i++)
	{
		//alert('ButtonOn ' +this.onState[i]);
	}

}
ButtonGroup.prototype.set=function(btn)
{
	for(var i = 0;i<this.buttonObj.length;i++)
	{
		if(btn == this.buttonObj[i])
		{
			this.buttonObj[i].firstChild.src = this.onState[i];
		}
		else
		{
			this.buttonObj[i].firstChild.src = this.offState[i];
		}
	}
}
ButtonToggle.prototype.toggleOff = 0;
ButtonToggle.prototype.toggleOn = 1;
ButtonToggle.prototype.currentState;
ButtonToggle.prototype.toggleObj;

function ButtonToggle(obj, selectedImg, unSelectedImg, state)
{
	this.currentState = state;
	this.toggleObj = obj;
	this.onStateImg = selectedImg;
	this.offStateImg = unSelectedImg;
	this.currentState =  state;
}
ButtonToggle.prototype.toggle=function()
{
	//currently unselected
	//toggle button so that it is selected
	if(this.currentState == this.toggleOff)
	{
		this.currentState = this.toggleOn;
		this.toggleObj.firstChild.src = this.onStateImg;
	}
	else
	{
		this.currentState = this.toggleOff;
		this.toggleObj.firstChild.src = this.offStateImg;
	}
}
ButtonToggle.prototype.setToggleOn=function()
{
	this.currentState = this.toggleOn;
	this.toggleObj.firstChild.src = this.onStateImg;
}
ButtonToggle.prototype.setToggleOff=function()
{
	this.currentState = this.toggleOff;
	this.toggleObj.firstChild.src = this.offStateImg;
}

// this method gets called from the HTML when body.onLoad()
function initViewer()
{
	window.parent.resizeTo(screen.availWidth, screen.availHeight);
	Viewer_addImages();
}

function Viewer_addImages()
{
	//get instance of applet from page
	imageViewer = document.getElementById('Viewer');
	try
	{
		if (MRPicRowId!="")  //non dicom image
		{
			var Pobj=document.getElementById('MRPicRowId');
			if (Pobj) Pobj.value=MRPicRowId;
			imageViewer.addSeries("1","1","0",MRPicRowId,VirtualDirectory+FileName,"",sessionId,questionCode,orderItemId);
			imageViewer.displayStudies();
		}
		else if ((mradm!="")&&(bStudy=="")&&(MRPicRowId=="")&&(accessionNo==""))  //non dicom image
		{
			imageViewer.addSeries("1","1","0",mradm,VirtualDirectory+FileName,"",sessionId,questionCode,orderItemId);
			imageViewer.displayStudies();
		}
		else if (bStudy!="")
		{
			//now using addseries method to add images
			//StudyID here corresponds to the Applet number to which the seires images should be added

			var count=0;
			var bSeries=""; var prevStudyID="";
			while (mPiece(bStudy,"~",count)!="") //go through string looking for ~ (seperates studies)
			{
				bSeries=mPiece(bStudy,"~",count); //split this string into individual series

				var StudyID=mPiece(bSeries,"^",0); //now go through remaining string looking for ^

				if (StudyID)
				{
					//seperate the string further into StudyInst, SeriesInst, OEOrdResults and Images
					//KK Set the applet according to study
					var SeriesID=mPiece(bSeries,"^",1);
					//alert('studyId ' + StudyID + ' seriesId ' + SeriesID);
					if (SeriesID=="")
						SeriesID="1"; //check incase series id is null
					var OEOrdResIds=mPiece(bSeries,"^",3);
					var sImages=mPiece(bSeries,"^",2);
					var sopInstanceUIDs=mPiece(bSeries,"^",4);
					imageViewer.addSeries(StudyID,SeriesID,"0",OEOrdResIds,sImages,sopInstanceUIDs);

				}
				count=count+1;
			}
			imageViewer.displayStudies();
		}
		/* PJC - Not being used at the moment
		 else if(accessionNo!="")
		{
			var i=0;
			while( mPiece(accessionNo,"^",i)!="" )
			{
				var accNum=mPiece(accessionNo,"^",i);
				var ordId=mPiece(accOrderIds,"^",i);
				imageViewer.findStudy(patientId,accNum,ordId);
				i=i+1;
			}
			imageViewer.displayStudies();
		}*/
		imageViewer.setAnnotationXML(annotationXml);
		imageViewer.onLoad();
	}
	catch(e)
	{
		alert(t['FailedToLoadImage']+e.message);
 	}
}

function SetActiveApplet(){
//Check isSelected() property of all the applets and set the active applet
		//alert("!");
		var D1=document.getElementById('Dicom1');
		var D2=document.getElementById('Dicom2');
		var D3=document.getElementById('Dicom3');
		var D4=document.getElementById('Dicom4');

		if (D1) var D1Selected=D1.isSelected();
		if (D2) var D2Selected=D2.isSelected();
		if (D3) var D3Selected=D3.isSelected();
		if (D4) var D4Selected=D4.isSelected();

		if (D1Selected) {
			//alert("App 1");
			av=document.getElementById('Dicom1');
		}
		if (D2Selected) {
			//alert("App 2");
			av=document.getElementById('Dicom2');
		}
		if (D3Selected) av=document.getElementById('Dicom3');
		if (D4Selected) av=document.getElementById('Dicom4');
}
function Viewer_NextStudy(evt)
{
	if (imageViewer) imageViewer.nextStudy();
	return false;
}
function StyFwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'nextStudyoff.gif';
}

function StyFwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'nextStudy.gif';
}
function Viewer_PreviousStudy(evt)
{
	if (imageViewer) imageViewer.previousStudy();
	return false;
}
function StyBwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previousStudyoff.gif';
}

function StyBwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previousStudy.gif';
}
function Viewer_StartAnimation(evt)
{
	btnStopStart.set(this);
	if (imageViewer) imageViewer.setMode('START');
	return false;
}
function Viewer_StopAnimation(evt)
{
	btnStopStart.set(this);
	if (imageViewer) imageViewer.setMode('STOP');
	return false;
}

function Viewer_NextFrame(evt)
{

	if (imageViewer) imageViewer.nextFrame();
	return false;
}
function NxtFrameMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'NextFrameoff.gif';
}

function NxtFrameMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'NextFrame.gif';
}
function Viewer_PreviousFrame(evt)
{
	if (imageViewer) imageViewer.previousFrame();
	return false;
}
function PrevFrameMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'PreviousFrameoff.gif';
}

function PrevFrameMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'PreviousFrame.gif';
}
function Viewer_IncreaseSpeed(evt)
{
	if (imageViewer) imageViewer.setMode('INCREASE_SPEED');
	return false;
}
function Viewer_DecreaseSpeed(evt)
{
	if (imageViewer) imageViewer.setMode('DECREASE_SPEED');
	return false;
}
function DecreaseSpeedMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'DecreaseSpeedoff.gif';
}
function DecreaseSpeedMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'DecreaseSpeed.gif';
}
function Viewer_DefaultSpeed(evt)
{
	if (imageViewer) imageViewer.setMode('DEF_SPEED');
	return false;
}

function Viewer_Imageforwards(evt)
{
	if (imageViewer) imageViewer.nextImage();
		return false;
}
function ImgFwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'nextoff.gif';
}
function ImgFwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'next.gif';
}
function Viewer_Imagebackwards(evt)
{
	if (imageViewer) imageViewer.previousImage();
	return false;
}
function ImgBwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previousoff.gif';
}
function ImgBwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previous.gif';
}



function Viewer_seriesforwards(evt)
{
	if (imageViewer) imageViewer.nextSeries();
	return false;
}
function SerNxtMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'nextseriesoff.gif';
}
function SerNxtMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'nextseries.gif';
}
function Viewer_seriesbackwards(evt)
{
	if (imageViewer) imageViewer.previousSeries();
}
function SerBwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previousseriesoff.gif';
}
function SerBwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'previousseries.gif';
}





function Viewer(sMode)
{
	//SetActiveApplet();
	sMode = "" + sMode + "";
	if (imageViewer) imageViewer.setMode(sMode);
	return false;
}
function Viewer_pan(evt)
{
	btnToolsGrp.set(this);
	if (imageViewer){
		imageViewer.setMode("PAN");
	}
	return false;
}


function Viewer(sMode)
{
	sMode = "" + sMode + "";
	if (imageViewer) imageViewer.setMode(sMode);
	return false;
}

function Viewer_zoom(evt)
{
	btnToolsGrp.set(this);
	 if (imageViewer) imageViewer.setMode("ZOOM");
	 return false;
}
function Viewer_rotateBwd(evt)
{
	if (imageViewer) imageViewer.setMode("ROTATE_BWD");
	return false;
}

function RotBwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'rotBwdoff.gif';
}
function RotBwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'rotBwd.gif';
}
function Viewer_rotateFwd(evt)
{
	if (imageViewer) imageViewer.setMode("ROTATE_FWD");
	//return false;
}
function RotFwdMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'rotFwdoff.gif';
}
function RotFwdMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'rotFwd.gif';
}
function Viewer_flipHorizontal(evt)
{
	if (imageViewer) imageViewer.setMode("VERTICAL_FLIP");
	//return false;
}

function flipHMouseDown(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'FlipHorizontaloff.gif';
}
function flipHMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'FlipHorizontal.gif';
}
function Viewer_flipVertical(evt)
{
	if (imageViewer) imageViewer.setMode("HORIZONTAL_FLIP");
	//return false;
}
function flipVMouseDown(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'FlipVerticaloff.gif';
}
function flipVMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'FlipVertical.gif';
}
function Viewer_lens(evt)
{
	btnToolsGrp.set(this);
	if(imageViewer)
		imageViewer.setMode("LENS");
	//return false;
}
function Viewer_fittoimage(evt)
{
	btnFitGrp.set(this);
	if (imageViewer) imageViewer.setMode("FITTOIMAGE");
	//return false;
}
function Viewer_fittowin(evt)
{
	btnFitGrp.set(this);
	if (imageViewer) imageViewer.setMode("FITTOWIN");
	//return false;
}
function Viewer_widthlevel(evt)
{
	btnToolsGrp.set(this);
	if (imageViewer) imageViewer.setMode("WIDTHLEVEL");
	//return false;
}
function Viewer_showpreview(evt)
{
	if (btnPreviewToggle) btnPreviewToggle.toggle();
	if (imageViewer) imageViewer.setMode("SHOWPREVIEW");
}
function Viewer_reset(evt)
{
	if (imageViewer) imageViewer.setMode("RESET");
}
function ResetMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'ltarrowoff.gif';
}

function ResetMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'ltarrow.gif';

}
function stoplink(evt)
{
 	return false;
}

function AppletSelect1(){
	//alert("1");
	//document.images["AppImg1"].src=imageLinked.src;
	var D1=document.getElementById('Dicom1');
	if ((D1) && (LinkApp1==false)) {
		D1.setAppletLinked(true);
		document['AppImg1'].src=imageLinked.src;
		LinkApp1=true;
	} else if ((D1) && (LinkApp1==true)) {
		D1.setAppletLinked(false);
		document['AppImg1'].src=imageUnLinked.src;
		LinkApp1=false;
		//AppSel1.src="..images/webemr/UnLinkedStudy.jpg"
	}
}

function AppletSelect2(){
	//alert("2");
	var D2=document.getElementById('Dicom2');
	if ((D2) && (LinkApp2==false)) {
		D2.setAppletLinked(true);
		document['AppImg2'].src=imageLinked.src;
		LinkApp2=true;
	} else  if ((D2) && (LinkApp2==true)) {
		D2.setAppletLinked(false);
		document['AppImg2'].src=imageUnLinked.src;
		LinkApp2=false;
	}

}
function AppletSelect3(){
	//alert("3");
	var D3=document.getElementById('Dicom3');
	if ((D3) && (LinkApp3==false)) {
		D3.setAppletLinked(true);
		document['AppImg3'].src=imageLinked.src;
		LinkApp3=true;
	} else  if ((D3) && (LinkApp3==true)) {
		D3.setAppletLinked(false);
		document['AppImg3'].src=imageUnLinked.src;
		LinkApp3=false;
	}

}
function AppletSelect4(){
	//alert("4");
	var D4=document.getElementById('Dicom4');
	if ((D4) && (LinkApp4==false)) {
		D4.setAppletLinked(true);
		document['AppImg4'].src=imageLinked.src;
		LinkApp4=true;
	} else if ((D4) && (LinkApp4==true)) {
		D4.setAppletLinked(false);
		document['AppImg4'].src=imageUnLinked.src;
		LinkApp4=false;
	}
}

function Resize() {
	var obj=document.getElementById('Dicom');
	if (obj) {
  		obj.width = document.body.clientWidth - 10;
  		obj.height = document.body.clientHeight - obj.offsetTop;
 	}
}
function doScroll(e){
	var vKey
 	if (window.event)
 		vKey = window.event.keyCode
	else
		vKey = e.which
 	//Page Up
 	if (vKey == "33")
  		imageViewer.backwards();
 		//Page Down
 	if (vKey == "34")
  	imageViewer.forwards();
}

function Viewer_Image1x1(evt){
	btnImgGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat('IMAGE_1x1');
 	return false;
}
function Viewer_Image2x1(evt){
	btnImgGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat("IMAGE_2x1");
 	return false;
}
function Viewer_Image1x2(evt)
{
 	btnImgGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat("IMAGE_1x2");
 	return false;
}
function Viewer_Image2x2(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_2x2");
 	return false;
}
function Viewer_Image3x2(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_3x2");
 	return false;
}
function Viewer_Image2x3(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_2x3");
 	return false;
}
function Viewer_Image3x3(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_3x3");
 	return false;
}
function Viewer_Image4x3(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_4x3");
 	return false;
}
function Viewer_Image3x4(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_3x4");
 	return false;
}
function Viewer_Image4x4(evt){
	btnImgGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("IMAGE_4x4");
	return false;
}


function activateButton(group, btnName) {

	var btn = document.getElementById(btnName);
	if (btn)
	{
		if (group == 'SERIES_GROUP')
			btnSeriesGrp.set(btn);
		else if (group == 'IMAGE_GROUP')
			btnImgGrp.set(btn);
		else if (group == 'ANNOTATION_GROUP')
			btnToolsGrp.set(btn);
		else if (group == 'TOOLS_GROUP')
			btnToolsGrp.set(btn);
		else if (group == 'FIT_GROUP')
			btnFitGrp.set(btn);
		else if (group == 'ANIMATION_GROUP')
			btnStopStart.set(btn);
	}
}

// set default layout for series or images, depending on the type
function selectLayoutButton(type, amount, splitMode)
{
	var btn;
	var col = '';
	var row = '';

	if (type != 'IMAGE' && type != 'SERIES')
		return;

	switch(amount)
	{
        case '1':
            col = '1';
            row = '1';
            break;
        case '2':
            col = '2';
            row = '1';
            break;
        case '3': case '4':
            col = '2';
            row = '2';
            break;
        case '5': case '6':
            col = '2';
            row = '3';
            break;
        case '7': case '8': case '9':
            col = '3';
            row = '3';
            break;
        case '10': case '11': case '12':
            col = '3';
            row = '4';
            break;
        case '13': case '14': case '15': case '16':
            col = '4';
            row = '4';
	}
	var temp;
	if (splitMode == "1") // HORIZONTAL
	{
		if (row - col != 0 && amount > 1) {
			temp = row;
			row = col;
			col = temp;
		}
	}
	var layout = col + 'x' + row;

	//alert("Default Layout for " + type + ": " + layout);

	if (layout == '1x1')
		btn = document.getElementById(type + '_FORMAT1x1');
	else if (layout == '2x1')
		btn = document.getElementById(type + '_FORMAT2x1');
	else if (layout == '2x2')
		btn = document.getElementById(type + '_FORMAT2x2');
	else if (layout == '1x2')
		btn = document.getElementById(type + '_FORMAT1x2');
	else if (layout == '2x2')
		btn = document.getElementById(type + '_FORMAT2x2');
	else if (layout == '3x3')
		btn = document.getElementById(type + '_FORMAT3x3');
	else if (layout == '3x2')
		btn = document.getElementById(type + '_FORMAT3x2');
	else if (layout == '2x3')
		btn = document.getElementById(type + '_FORMAT2x3');
	else if (layout == '4x3')
		btn = document.getElementById(type + '_FORMAT4x3');
	else if (layout == '3x4')
		btn = document.getElementById(type + '_FORMAT3x4');
	else if (layout == '4x4')
		btn = document.getElementById(type + '_FORMAT4x4');
	else if (layout == '5x4')
		btn = document.getElementById(type + '_FORMAT5x4');
	else if (layout == '4x5')
		btn = document.getElementById(type + '_FORMAT4x5');
	else if (layout == '5x5')
		btn = document.getElementById(type + '_FORMAT5x5');

	if (btn && type == 'SERIES')
		btnSeriesGrp.set(btn);
	else if (btn && type == 'IMAGE')
		btnImgGrp.set(btn);
}

function Viewer_Series1x1(evt)
{
	var eSrc=websys_getSrcElement(evt);
	btnSeriesGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat("SERIES_1x1");
 	return false;
}

function Viewer_Series2x1(evt)
{
	var eSrc=websys_getSrcElement(evt);
	btnSeriesGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat("SERIES_2x1");
 	return false;
}
function Viewer_Series1x2(evt)
{
	var eSrc=websys_getSrcElement(evt);
	btnSeriesGrp.set(this);
 	if (imageViewer)
		imageViewer.setFormat("SERIES_1x2");
 	return false;
}
function Viewer_Series2x2(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_2x2");
 	return false;
}
function Viewer_Series3x2(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_3x2");
 	return false;
}
function Viewer_Series2x3(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_2x3");
 	return false;
}

function Viewer_Series3x3(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_3x3");
 	return false;
}

function Viewer_Series4x3(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_4x3");
 	return false;
}
function Viewer_Series3x4(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_3x4");
 	return false;
}
function Viewer_Series4x4(evt){
	btnSeriesGrp.set(this);
	if (imageViewer)
		imageViewer.setFormat("SERIES_4x4");
	return false;
}

function Viewer_invert(evt){
	if (btnInvertToggle) btnInvertToggle.toggle();
	if (imageViewer) imageViewer.setMode("INVERT");
	return false;
}
function Viewer_Scrollimages()
{
	btnToolsGrp.set(this);
	if (imageViewer)
		imageViewer.setMode("IMAGE_SCROLL");
}

function Viewer_ToggleView(evt)
{
	if (btnSeriesStudyViewToggle) btnSeriesStudyViewToggle.toggle();
	if (imageViewer)
	{
		imageViewer.setViewingLevel(btnSeriesStudyViewToggle.currentState);
	}
	return false;
}
function Viewer_showPropertiesPage(evt)
{
	if (btnPropertyPageToggle) btnPropertyPageToggle.toggle();
	if (imageViewer)
	{
		imageViewer.showPropertiesPage();
	}
}
function Viewer_toggleThumbnails(evt)
{
	if (btnThumbToggle) btnThumbToggle.toggle();
	if (imageViewer)
	{
		imageViewer.toggleThumbnails();
	}
}
function toggleThumbsMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Thumbnailsoff.gif';
}

function toggleThumbsMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Thumbnails..gif';
}

function Viewer_ExplodeStudy(evt)
{
	if (imageViewer) imageViewer.explodeStudy();
}
function explodeStudyMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Explosionoff.gif';
}
function explodeStudyMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Explosion.gif';
}
function Viewer_Redo(evt)
{
	if (imageViewer) imageViewer.setMode("REDO");
}

function RedoMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Redooff.gif';

}

function RedoMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Redo.gif';

}
function Viewer_Undo(evt)
{
	if (imageViewer) imageViewer.setMode("UNDO");
}

function UndoMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Undooff.gif';

}

function UndoMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Undo.gif';
}

//----------- Event methods for Annotation tools -----------
function Viewer_Ruler(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) imageViewer.setMode("MEASURE_LINE");
	return false;
}
function Viewer_ToggleRuler(evt)
{
	if (btnRulerToggle) btnRulerToggle.toggle();
	if (imageViewer)
		imageViewer.setMode("TOGGLE_MEASUREMENTS");
	return false;
}
function Viewer_Angle(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) imageViewer.setMode("MEASURE_ANGLE");
	return false;
}
function Viewer_ToggleAngles(evt)
{
	if (btnAnglesToggle) btnAnglesToggle.toggle();
	if (imageViewer)
		imageViewer.setMode("TOGGLE_ANGLES");
	return false;
}
function Viewer_BoxShape(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) {
		imageViewer.setMode("BOX_ANNOTATE");
	}
	return false;
}
function Viewer_EllipseShape(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) {
		imageViewer.setMode("ELLIPSE_ANNOTATE");
	}
	return false;
}
function Viewer_ShapeSelection(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) {
		imageViewer.setMode("SHAPE_SELECTION");
	}
	return false;
}
function Viewer_FreeHand(evt){
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) {
		imageViewer.setMode("FREE_HAND");
	}
	return false;
}
function  Viewer_DrawLine(evt){
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();
	if (btnAnnotationsToggle) btnAnnotationsToggle.setToggleOff();

	btnToolsGrp.set(this);
	if (imageViewer) {
		imageViewer.setMode("LINE_ANNOTATE");
	}
	return false;
}

function Viewer_SaveAnnotate(evt)
{
	if (imageViewer) {
		imageViewer.setMode("SAVE_ANNOTATIONS");
		var xml=imageViewer.getAnnotationXML();
		var Xobj=document.getElementById('XMLAnnotation');
		if (Xobj) Xobj.value=xml;
	}
	//displayAnnotationSavedMessage(); //removed unnecessary alert
	update1_click();
	return false;
}

function displayAnnotationSavedMessage() {
	alert(t['AnnotSaved']);
}
function displayAnnotationSaveFailedMessage() {
	alert(t['AnnotSaveFailed']);
}
function saveAnnotateMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Updateoff.gif';
}
function saveAnnotateMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Update.gif';

}
function Viewer_Delete(evt)
{
	if (imageViewer)
		imageViewer.setMode("DELETE_TRAK_ANNOTS");
	return false;
}
function DeleteAllMouseDwn(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Deleteoff.gif';
}
function DeleteAllMouseUp(evt)
{
	var eSrc=websys_getSrcElement(evt);
	eSrc.src=IMGPath+'Delete.gif';
}
function Viewer_TOGGLE(evt)
{
	if (btnRulerToggle) btnRulerToggle.setToggleOff();
	if (btnAnglesToggle) btnAnglesToggle.setToggleOff();

	if (btnAnnotationsToggle) btnAnnotationsToggle.toggle();
	if (imageViewer)
		imageViewer.setMode("TOGGLE_TRAK_ANNOTS");
	return false;
}

var Uobj=document.getElementById('update1');
if (Uobj)
{
	Uobj.onclick = Viewer_SaveAnnotate;
	Uobj.onmousedown = saveAnnotateMouseDwn;
	Uobj.onmouseup = saveAnnotateMouseUp;
}
var boxshpobj=document.getElementById('BoxShape');
if (boxshpobj)
{
	boxshpobj.onclick = Viewer_BoxShape;
	btnToolsGrp.add(boxshpobj, IMGPath+'BoxAnnotoff.gif', IMGPath+'BoxAnnot.gif');
}
var elipseShpobj=document.getElementById('EllipseShape');
if (elipseShpobj)
{
	elipseShpobj.onclick = Viewer_EllipseShape;
	btnToolsGrp.add(elipseShpobj, IMGPath+'ElipseAnnotoff.gif', IMGPath+'ElipseAnnot.gif');
}

var shpSelectobj=document.getElementById('ShapeSelection');
if (shpSelectobj)
{
	shpSelectobj.onclick = Viewer_ShapeSelection;
	btnToolsGrp.add(shpSelectobj, IMGPath+'ShapeSelectedoff.gif', IMGPath+'ShapeSelected.gif');
}

var FHobj=document.getElementById('FreeHand');
if (FHobj)
{
	FHobj.onclick = Viewer_FreeHand;
	btnToolsGrp.add(FHobj, IMGPath+'FreeHandoff.gif', IMGPath+'FreeHand.gif');
}
var LNobj=document.getElementById('DrawLine');
if (LNobj)
{
	LNobj.onclick = Viewer_DrawLine;
	btnToolsGrp.add(LNobj, IMGPath+'drawlineoff.gif', IMGPath+'drawline.gif');
}
var DeleteAllObj = document.getElementById('DeleteAll');
if(DeleteAllObj)
{
	DeleteAllObj.onclick = Viewer_Delete;
	DeleteAllObj.onmousedown = DeleteAllMouseDwn;
	DeleteAllObj.onmouseup = DeleteAllMouseUp;

}
var ToggleAnnotObj = document.getElementById('Toggle');
if(ToggleAnnotObj)
{
	ToggleAnnotObj.onclick = Viewer_TOGGLE;
	btnAnnotationsToggle = new ButtonToggle(ToggleAnnotObj, IMGPath+'Toggleoff.gif', IMGPath+'Toggle.gif', ButtonToggle.prototype.toggleOff);
	//btnAnnotationsToggle.toggle();
}
var NxtImgobj=document.getElementById('Next');
if(NxtImgobj)
{
	NxtImgobj.onclick = Viewer_Imageforwards;
	NxtImgobj.onmousedown=ImgFwdMouseDwn;
	NxtImgobj.onmouseup=ImgFwdMouseUp;
}
var PrevImgobj=document.getElementById('Previous');
if(PrevImgobj)
{
	PrevImgobj.onclick = Viewer_Imagebackwards;
	PrevImgobj.onmousedown = ImgBwdMouseDwn;
	PrevImgobj.onmouseup = ImgBwdMouseUp;
}
var NxtStyobj = document.getElementById('NextStudy');
if(NxtStyobj)
{
	NxtStyobj.onclick = Viewer_NextStudy;
	NxtStyobj.onmousedown = StyFwdMouseDwn;
	NxtStyobj.onmouseup = StyFwdMouseUp;
}
var PrevStyobj = document.getElementById('PreviousStudy');
if(PrevStyobj)
{
	PrevStyobj.onclick = Viewer_PreviousStudy;
	PrevStyobj.onmousedown = StyBwdMouseDwn;
	PrevStyobj.onmouseup = StyBwdMouseUp;
}

var NxtFrameobj=document.getElementById('NextFrame');

if (NxtFrameobj)
{
	NxtFrameobj.onclick = Viewer_NextFrame;
	NxtFrameobj.onmousedown = NxtFrameMouseDwn;
	NxtFrameobj.onmouseup = NxtFrameMouseUp;
}

var PrvFrameobj=document.getElementById('PreviousFrame');
if (PrvFrameobj)
{
	PrvFrameobj.onclick = Viewer_PreviousFrame;
	PrvFrameobj.onmousedown = PrevFrameMouseDwn;
	PrvFrameobj.onmouseup = PrevFrameMouseUp;
}
var StartAnimobj=document.getElementById('StartAnimation');
if (StartAnimobj)
{
	StartAnimobj.onclick = Viewer_StartAnimation;
	btnStopStart.add(StartAnimobj, IMGPath + 'startAnimationoff.gif', IMGPath + 'startAnimation.gif');
}
var StopAnimobj=document.getElementById('StopAnimation');
if (StopAnimobj)
{
	StopAnimobj.onclick = Viewer_StopAnimation;
	btnStopStart.add(StopAnimobj, IMGPath + 'stopAnimationoff.gif', IMGPath + 'stopAnimation.gif');
}
btnStopStart.set(StopAnimobj);

var DefalutSpeedobj=document.getElementById('DefaultSpeed');
if (DefalutSpeedobj) DefalutSpeedobj.onclick = Viewer_DefaultSpeed;

var IncreaseSpeedobj=document.getElementById('IncreaseSpeed');
if (IncreaseSpeedobj) IncreaseSpeedobj.onclick = Viewer_IncreaseSpeed;

var DecreaseSpeedobj=document.getElementById('DecreaseSpeed');
if (DecreaseSpeedobj)
{
	DecreaseSpeedobj.onclick = Viewer_DecreaseSpeed;
	DecreaseSpeedobj.onmousedown = DecreaseSpeedMouseDwn;
	DecreaseSpeedobj.onmouseup = DecreaseSpeedMouseUp;
}
var NXTSeriesobj=document.getElementById('NextSeries');
if (NXTSeriesobj)
{
	NXTSeriesobj.onclick = Viewer_seriesforwards;
	NXTSeriesobj.onmousedown = SerNxtMouseDwn;
	NXTSeriesobj.onmouseup = SerNxtMouseUp;
}

var PRVSeriesobj=document.getElementById('PreviousSeries');
if (PRVSeriesobj)
{
	PRVSeriesobj.onclick = Viewer_seriesbackwards;
	PRVSeriesobj.onmousedown = SerBwdMouseDwn;
	PRVSeriesobj.onmouseup = SerBwdMouseUp;
}

var Pobj=document.getElementById('Pan');
if (Pobj)
{
	Pobj.onclick = Viewer_pan;
	btnToolsGrp.add(Pobj, IMGPath+'moveImageoff.gif', IMGPath+'moveImage.gif');
}
var Zobj=document.getElementById('Zoom');
if (Zobj)
{
	Zobj.onclick = Viewer_zoom;
	btnToolsGrp.add(Zobj, IMGPath+'paninoff.gif', IMGPath+'panin.gif');
}

var Lobj=document.getElementById('Lens');  //zoom
if (Lobj)
{
	Lobj.onclick = Viewer_lens;
	btnToolsGrp.add(Lobj, IMGPath+'magvwroff.gif', IMGPath+'magvwr.gif');
}
var AWLobj=document.getElementById('WidthLevel');  // width/level
if (AWLobj)
{
	AWLobj.onclick = Viewer_widthlevel;
	btnToolsGrp.add(AWLobj, IMGPath+'winLev2off.gif', IMGPath+'winLev2.gif');
}
////////////////////////////////////////////////////


var RBwdobj=document.getElementById('rotateBwd');
if (RBwdobj)
{
	RBwdobj.onclick = Viewer_rotateBwd;
	RBwdobj.onmousedown = RotBwdMouseDwn;
	RBwdobj.onmouseup = RotBwdMouseUp;

}
var RotFwdobj=document.getElementById('rotateFwd');
if (RotFwdobj)
{
	RotFwdobj.onclick = Viewer_rotateFwd;
	RotFwdobj.onmousedown = RotFwdMouseDwn;
	RotFwdobj.onmouseup = RotFwdMouseUp;
}
var FlipHObj=document.getElementById('FlipHorizontal');
if (FlipHObj)
{
	FlipHObj.onclick = Viewer_flipHorizontal;
	FlipHObj.onmousedown = flipHMouseDown;
	FlipHObj.onmouseup = flipHMouseUp;
}
var FlipVObj=document.getElementById('FlipVertical');
if (FlipVObj)
{
	FlipVObj.onclick = Viewer_flipVertical;
	FlipVObj.onmousedown = flipVMouseDown;
	FlipVObj.onmouseup = flipVMouseUp;
}

var FWobj=document.getElementById('FitWindow');
if (FWobj)
{
	FWobj.onclick = Viewer_fittowin;
	btnFitGrp.add(FWobj, IMGPath+'fitwinskulloff.gif', IMGPath+'fitwinskull.gif');
}
var FIobj=document.getElementById('FitImage');
if (FIobj)
{
	FIobj.onclick = Viewer_fittoimage;
	btnFitGrp.add(FIobj, IMGPath+'fitscroff.gif', IMGPath+'fitscr.gif');
}

var SPobj=document.getElementById('ShowPreview');
if (SPobj)
{
	SPobj.onclick = Viewer_showpreview;
	btnPreviewToggle = new ButtonToggle(SPobj, IMGPath+'prevwskloff.gif', IMGPath+'prevwskl.gif', ButtonToggle.prototype.toggleOff);
}
var RIobj=document.getElementById('ResetImage');
if (RIobj)
{
	RIobj.onclick = Viewer_reset;
	RIobj.onmouseDown = ResetMouseDwn;
	RIobj.onmouseup = ResetMouseUp;
}


var H1obj=document.getElementById('IMAGE_FORMAT1x1');
if (H1obj)
{
	H1obj.onclick = Viewer_Image1x1;
	btnImgGrp.add(H1obj, IMGPath+'image1x1off.gif', IMGPath+'image1x1.gif');
}
var H2obj=document.getElementById('IMAGE_FORMAT1x2');
if (H2obj)
{
	H2obj.onclick = Viewer_Image1x2;
	btnImgGrp.add(H2obj, IMGPath+'image1x2off.gif', IMGPath+'image1x2.gif');
}
var H2Uobj=document.getElementById('IMAGE_FORMAT2x1');
if (H2Uobj)
{
	H2Uobj.onclick = Viewer_Image2x1;
	btnImgGrp.add(H2Uobj, IMGPath+'image2x1off.gif', IMGPath+'image2x1.gif');
}
var H4obj=document.getElementById('IMAGE_FORMAT2x2');
if (H4obj)
{
	H4obj.onclick = Viewer_Image2x2;
	btnImgGrp.add(H4obj, IMGPath+'image2x2off.gif', IMGPath+'image2x2.gif');
}
var H6obj=document.getElementById('IMAGE_FORMAT3x2');
if (H6obj)
{
	H6obj.onclick = Viewer_Image3x2;
	btnImgGrp.add(H6obj, IMGPath+'image3x2off.gif', IMGPath+'image3x2.gif');
}
var H6Uobj=document.getElementById('IMAGE_FORMAT2x3');
if (H6Uobj)
{
	H6Uobj.onclick = Viewer_Image2x3;
	btnImgGrp.add(H6Uobj, IMGPath+'image2x3off.gif', IMGPath+'image2x3.gif');
}
var H9obj=document.getElementById('IMAGE_FORMAT3x3');
if (H9obj)
{
	H9obj.onclick = Viewer_Image3x3;
	btnImgGrp.add(H9obj, IMGPath+'image3x3off.gif', IMGPath+'image3x3.gif');
}
var H12obj=document.getElementById('IMAGE_FORMAT4x3');
if (H12obj)
{
	H12obj.onclick = Viewer_Image4x3;
	btnImgGrp.add(H12obj, IMGPath+'image4x3off.gif', IMGPath+'image4x3.gif');
}
var H12Uobj=document.getElementById('IMAGE_FORMAT3x4');
if (H12Uobj)
{
	H12Uobj.onclick = Viewer_Image3x4;
	btnImgGrp.add(H12Uobj, IMGPath+'image3x4off.gif', IMGPath+'image3x4.gif');
}
var H16obj=document.getElementById('IMAGE_FORMAT4x4');
if (H16obj)
{
	H16obj.onclick = Viewer_Image4x4;
	btnImgGrp.add(H16obj, IMGPath+'image4x4off.gif', IMGPath+'image4x4.gif');
}



var HS1obj=document.getElementById('SERIES_FORMAT1x1');
if (HS1obj)
{
	HS1obj.onclick = Viewer_Series1x1;
	btnSeriesGrp.add(HS1obj, IMGPath+'series1x1off.gif', IMGPath+'series1x1.gif');
}
var HS2obj=document.getElementById('SERIES_FORMAT2x1');
if (HS2obj)
{
	HS2obj.onclick = Viewer_Series2x1;
	btnSeriesGrp.add(HS2obj, IMGPath+'series2x1off.gif', IMGPath+'series2x1.gif');
}
var HS2Uobj=document.getElementById('SERIES_FORMAT1x2');
if (HS2Uobj)
{
	HS2Uobj.onclick = Viewer_Series1x2;
	btnSeriesGrp.add(HS2Uobj, IMGPath+'series1x2off.gif', IMGPath+'series1x2.gif');
}
var HS4obj=document.getElementById('SERIES_FORMAT2x2');
if (HS4obj)
{
	HS4obj.onclick = Viewer_Series2x2;
	btnSeriesGrp.add(HS4obj, IMGPath+'series2x2off.gif', IMGPath+'series2x2.gif');
}
var HS6obj=document.getElementById('SERIES_FORMAT3x2');
if (HS6obj)
{
	HS6obj.onclick = Viewer_Series3x2;
	btnSeriesGrp.add(HS6obj, IMGPath+'series3x2off.gif', IMGPath+'series3x2.gif');
}
var HS6Uobj=document.getElementById('SERIES_FORMAT2x3');
if (HS6Uobj)
{
	HS6Uobj.onclick = Viewer_Series2x3;
	btnSeriesGrp.add(HS6Uobj, IMGPath+'series2x3off.gif', IMGPath+'series2x3.gif');
}
var HS9obj=document.getElementById('SERIES_FORMAT3x3');
if (HS9obj)
{
	HS9obj.onclick = Viewer_Series3x3;
	btnSeriesGrp.add(HS9obj, IMGPath+'series3x3off.gif', IMGPath+'series3x3.gif');
}
var HS12obj=document.getElementById('SERIES_FORMAT4x3');
if (HS12obj)
{
	HS12obj.onclick = Viewer_Series4x3;
	btnSeriesGrp.add(HS12obj, IMGPath+'series4x3off.gif', IMGPath+'series4x3.gif');
}

var HS12Uobj=document.getElementById('SERIES_FORMAT3x4');
if (HS12Uobj)
{
	HS12Uobj.onclick = Viewer_Series3x4;
	btnSeriesGrp.add(HS12Uobj, IMGPath+'series3x4off.gif', IMGPath+'series3x4.gif');
}
var HS16obj=document.getElementById('SERIES_FORMAT4x4');
if (HS16obj)
{
	HS16obj.onclick = Viewer_Series4x4;
	btnSeriesGrp.add(HS16obj, IMGPath+'series4x4off.gif', IMGPath+'series4x4.gif');

}
//add all buttons



document.onkeyup = doScroll;

var IVobj=document.getElementById('invert');
if (IVobj)
{
	IVobj.onclick = Viewer_invert;
	btnInvertToggle = new ButtonToggle(IVobj, IMGPath+'invertoff.gif', IMGPath+'invert.gif', ButtonToggle.prototype.toggleOff);

}
var SRLobj=document.getElementById("Scrollimages");
if (SRLobj)
{
	SRLobj.onclick = Viewer_Scrollimages;
	btnToolsGrp.add(SRLobj, IMGPath+'scrolloff.gif', IMGPath+'scroll.gif');
}
var rulerObj=document.getElementById("Ruler");
if (rulerObj)
{
	rulerObj.onclick = Viewer_Ruler;
	btnToolsGrp.add(rulerObj, IMGPath+'ruleroff.gif', IMGPath+'ruler.gif');
}
var TRobj=document.getElementById("ToggleRuler");
if (TRobj)
{
	TRobj.onclick = Viewer_ToggleRuler;
	btnRulerToggle = new ButtonToggle(TRobj, IMGPath+ 'rulerxoff.gif', IMGPath + 'rulerx.gif', ButtonToggle.prototype.toggleOff);
}
var AGLobj=document.getElementById("Angle");
if (AGLobj)
{
	AGLobj.onclick = Viewer_Angle;
	btnToolsGrp.add(AGLobj, IMGPath+'msangleoff.gif', IMGPath+'msangle.gif');
}
var TAobj=document.getElementById("ToggleAngle");
if (TAobj)
{
	TAobj.onclick = Viewer_ToggleAngles;
	btnAnglesToggle = new ButtonToggle(TAobj, IMGPath+ 'msrangleXoff.gif', IMGPath + 'msrangleX.gif', ButtonToggle.prototype.toggleOff);
}
var TVobj=document.getElementById("TOGGLEVIEW");
if (TVobj)
{
	TVobj.onclick = Viewer_ToggleView;
	btnSeriesStudyViewToggle = new ButtonToggle(TVobj, IMGPath+ 'viewLeveloff.gif', IMGPath + 'viewLevel.gif', ButtonToggle.prototype.toggleOff);
}
var Propobj=document.getElementById("PROPERTIESPAGE");
if (Propobj)
{
	Propobj.onclick = Viewer_showPropertiesPage;
	btnPropertyPageToggle = new ButtonToggle(Propobj, IMGPath+ 'PropertiesPageoff.gif', IMGPath + 'PropertiesPage.gif', ButtonToggle.prototype.toggleOff);
}

var ToggleThumbobj=document.getElementById("TOGGLETHUMBNAILS");
if (ToggleThumbobj)
{
	ToggleThumbobj.onclick = Viewer_toggleThumbnails;
	btnThumbToggle = new ButtonToggle(ToggleThumbobj, IMGPath+ 'Thumbnailsoff.gif', IMGPath + 'Thumbnails.gif', ButtonToggle.prototype.toggleOff);
}
var ExplodeStudy=document.getElementById("Explode");
if (ExplodeStudy)
{
	ExplodeStudy.onclick = Viewer_ExplodeStudy;
	ExplodeStudy.onmousedown = explodeStudyMouseDwn;
	ExplodeStudy.onmouseup = explodeStudyMouseUp;
}
var RedoAction=document.getElementById("Redo");
if (RedoAction)
{
	RedoAction.onclick = Viewer_Redo;
	RedoAction.onmousedown = RedoMouseDwn;
	RedoAction.onmouseup = RedoMouseUp;
}
var UndoAction=document.getElementById("Undo");
if (UndoAction)
{
	UndoAction.onclick = Viewer_Undo;
	UndoAction.onmousedown = UndoMouseDwn;
	UndoAction.onmouseup = UndoMouseUp;
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}
