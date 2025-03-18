using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using SeanLib.CoreEditor;
[CustomEditor(typeof(VFXImage))]
public class VFXImageInspector : Editor
{
    SerializedProperty CustomMesh, UV2, Animatable;
	SerializedProperty prop_colorAdjust,prop_Contrast,prop_Saturation,prop_Brightness,prop_matColorAdjust;
	private void OnEnable()
    {
        CustomMesh= this.serializedObject.FindProperty("CustomMesh");
        UV2 = this.serializedObject.FindProperty("UV2");
	    Animatable = this.serializedObject.FindProperty("animatable");
	    //color adjust controllers
	    
	    prop_colorAdjust = this.serializedObject.FindProperty("colorAdjust");
	    prop_Contrast = this.serializedObject.FindProperty("Contrast");
	    prop_Saturation = this.serializedObject.FindProperty("Saturation");
	    prop_Brightness = this.serializedObject.FindProperty("Brightness");
	    prop_matColorAdjust = this.serializedObject.FindProperty("sharedMat_ColorAdjust");
    }
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(CustomMesh);
        if(CustomMesh.objectReferenceValue)
        {
            EditorGUILayout.PropertyField(UV2);
        }        
	    if(prop_colorAdjust.isExpanded=OnGUIUtility.Layout.BeginContainer(prop_colorAdjust.isExpanded,"ColorAdjust"))
	    {
		    EditorGUILayout.PropertyField(prop_colorAdjust,new GUIContent("Enable"));
		    EditorGUILayout.PropertyField(prop_Contrast);
		    EditorGUILayout.PropertyField(prop_Saturation);
		    EditorGUILayout.PropertyField(prop_Brightness);
		    EditorGUILayout.PropertyField(prop_matColorAdjust);
	    }
	    OnGUIUtility.Layout.EndContainer();
	    
	    if(Animatable.isExpanded=OnGUIUtility.Layout.BeginContainer(Animatable.isExpanded,"Material Animation"))
	    {
		    EditorGUILayout.PropertyField(Animatable,new GUIContent("Enable"));
		    EditorGUILayout.PropertyField( this.serializedObject.FindProperty("AnimProperties"));
	    }
	    OnGUIUtility.Layout.EndContainer();
        
        if (EditorGUI.EndChangeCheck())
        {
            serializedObject.ApplyModifiedProperties();
        }
    }
}
