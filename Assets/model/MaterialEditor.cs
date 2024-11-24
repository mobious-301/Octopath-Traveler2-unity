using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using LitJson;
// using System.Runtime.Serialization;
// using System;

public class MaterialEditor : EditorWindow
{
    // public string myString = "Hello World";
    // public bool groupEnabled;
    // bool myBool = true;
    // float myFloat = 1.23f;
    public Texture2D newTexture; // 通过 Inspector 选择新的纹理
    public static string filePath;

    // [ContextMenu("Set Texture to Selected Object")]
    [MenuItem("Tools/setTex")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        MaterialEditor window = (MaterialEditor)EditorWindow.GetWindow(typeof(MaterialEditor));
        window.Show();

    }
    int _texid;
    void OnGUI()
    {
        GUILayout.Label("Base Settings", EditorStyles.boldLabel);
        filePath = EditorGUILayout.TextField("Text Field", filePath);


        if (GUILayout.Button("选择texInfo文件"))
        {
            Selectiona();
        }

        _texid = EditorGUILayout.IntField("texid", _texid);
        if (GUILayout.Button("确认更新选中物体材质 base color"))
        {
            setTexForMat(materialTexName._BaseMap,_texid);

        }

        if (GUILayout.Button("确认更新选中物体材质 BumpMap"))
        {
            setTexForMat(materialTexName._BumpMap,_texid);

        }


        // if(GUILayout.Button("测试贴图")){
        //     LoadImageFromAssets("000001BB57183BF8.png");
        // }


        // EditorGUILayout.EndToggleGroup();
    }
    public void Selectiona()
    {
        //选择文件
        filePath = EditorUtility.OpenFilePanel("选择打开文件", UnityEngine.Application.streamingAssetsPath, "json");

    }
    Material getObjMat(GameObject selectedObject)
    {
        // 获取当前选中的物体
        // GameObject selectedObject = Selection.activeGameObject;

        if (selectedObject == null)
        {
            Debug.LogError("No object selected.");
            return null;
        }

        // 获取物体上的 Renderer 组件
        Renderer renderer = selectedObject.GetComponent<Renderer>();

        if (renderer == null)
        {
            Debug.LogError("Selected object does not have a Renderer component.");
            return null;
        }

        // 获取 Renderer 的材质
        // Material material = renderer.material;
        Material material = renderer.sharedMaterial;//本地材质文件


        if (material == null)
        {
            Debug.LogError("Renderer does not have a material.");
            return null;
        }

        // 设置材质的主纹理
        // material.mainTexture = newTexture;

        // Debug.Log("Texture set to selected object: " + selectedObject.name);
        return material;
    }



    static TexInfo texInfo = new TexInfo();



    public void setTexForMat(materialTexName TexType,int texid)
    {
        _texid=texid;
        doSetTexForMat(TexType.ToString());


    }


    public enum materialTexName
    {
        _BaseMap,
        _BumpMap,
        _EmissionMap
    }

    Texture2D LoadImageFromAssets(string fileName)
    {
        // 查找纹理资源
        // string[] guids = AssetDatabase.FindAssets("t:Texture2D " + fileName);
        // if (guids.Length > 0)
        // {
        //     string assetPath = AssetDatabase.GUIDToAssetPath(guids[0]);
        //     return AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath);
        // }


        // 加载纹理资源
        string assetPath = "Assets/Resources/Textures/" + fileName;
        Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath);
        return texture;
    }

    string[] getTexInfoByName(string name)
    {
        for (int i = 0; i < texInfo.TexInfos.Length; i++)
        {
            if (texInfo.TexInfos[i][0] == name)
            {
                return GetArrayExceptFirst(texInfo.TexInfos[i]);
            }
        }
        return null;
    }

    string[] GetArrayExceptFirst(string[] TexInfos)
    {

        List<string> outstr = new List<string>();

        for (int i = 1; i < TexInfos.Length; i++)
        {
            outstr.Add(TexInfos[i]);
        }

        // 将 List 转换回数组
        string[] newArray = outstr.ToArray();
        return newArray;
    }


    public static TexInfo getTexInfo(string filePath)
    {

        if (filePath == null) return null;
        
        // 解析 JSON 字符串
        // 读取文件内容
        string fileContent = File.ReadAllText(filePath);
        if (fileContent == null) return null;
        // ser();

        // 假设我们有一个 JSON 字符串
        //  fileContent = "[[\"Hello\",\"World\"],[\"Unity\",\"JsonUtility\"]]";
        Debug.Log("{\"TexInfos\":" + fileContent + "}");

        TexInfo texInfo = JsonMapper.ToObject<TexInfo>("{\"TexInfos\":" + fileContent + "}"); //二维数组 必须JsonMapper

        return texInfo; 
    }

    void doSetTexForMat(string TexTypeStr)
    {
        texInfo = getTexInfo(filePath);
        if (texInfo == null) return;
        // 获取当前选中的多个物体
        Object[] selectedObjects = Selection.objects;

        if (selectedObjects.Length == 0)
        {
            Debug.LogError("No objects selected.");
            return;
        }

        GameObject obji;

        foreach (Object obj in selectedObjects)
        {
            if (obj is GameObject)
            {
                obji = (GameObject)obj;
                if (obji == null) continue;

                string[] texs = getTexInfoByName(obj.name);
                if (texs == null) continue;

                Material material = getObjMat(obji);
                int texid = 0;
                if (texs.Length >= 9)
                {
                    texid = 8;
                }
                else
                {
                    texid = texs.Length - 1;
                }

                if (_texid >= texs.Length)
                {
                    texid = texs.Length - 1;
                }
                else
                {
                    texid = _texid;
                }
                //注意 数组包含文件头


                // switch (TexType)
                // {
                //     case materialTexName.mainTexture:
                //         material.mainTexture = LoadImageFromAssets(texs[texid] + ".png");
                //         break;
                //     case materialTexName.BumpMap:
                // 设置材质的法线贴图
                material.SetTexture(TexTypeStr, LoadImageFromAssets(texs[texid] + ".png"));
                // break;

            }
        }
    }
    public void setTexForMat(TerrainMatCtr TexType,int texid)
    {
        _texid=texid;
        
        doSetTexForMat(TexType.ToString());



    }


}


public enum TerrainMatCtr
{
    _Control,
    _Splat3,
    _Splat2,
    _Splat1,
    _Splat0,

    _Normal3,
    _Normal2,
    _Normal1,
    _Normal0,
}



[System.Serializable]
public class TexInfo
{
    public string[][] TexInfos { get; set; }
}



public class MaterialEditorTerrain : MaterialEditor
{

    // public Texture2D newTexture; // 通过 Inspector 选择新的纹理
    // static string filePath;



    [MenuItem("Tools/setTex1")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        MaterialEditorTerrain window = (MaterialEditorTerrain)EditorWindow.GetWindow(typeof(MaterialEditorTerrain));
        window.Show();

    }

    int _texida;
    void OnGUI()
    {
        GUILayout.Label("Base Settings", EditorStyles.boldLabel);
        filePath = EditorGUILayout.TextField("Text Field", filePath);


        if (GUILayout.Button("选择texInfo文件"))
        {
            Selectiona();
        }

        _texida = EditorGUILayout.IntField("texid", _texida);
        // if (GUILayout.Button("确认更新选中物体材质 base color"))
        // {
        //     setTexForMat(materialTexName.mainTexture);

        // }


        op = (TerrainMatCtr)EditorGUILayout.EnumPopup("Primitive to create:", op);
        if (GUILayout.Button("Create"))
            setTexForMat(op,_texida);


        EditorGUILayout.LabelField("这是一个文本提示  歧路旅人常用 6 8 14");



        // if (GUILayout.Button("确认更新选中物体材质 BumpMap"))
        // {
        //     setTexForMat(materialTexName._BumpMap);

        // }
    }
    TerrainMatCtr op;





}