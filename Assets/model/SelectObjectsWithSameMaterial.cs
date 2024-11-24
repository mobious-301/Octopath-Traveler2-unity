using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class SelectObjectsWithSameMaterial : EditorWindow
{
    // [MenuItem("Tools/Select Objects with Same Material")]
     [MenuItem("Tools/Select Objects with Same Material")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        SelectObjectsWithSameMaterial window = (SelectObjectsWithSameMaterial)EditorWindow.GetWindow(typeof(SelectObjectsWithSameMaterial));
        window.Show();

    }

    void OnGUI()
    {
        GUILayout.Label("Select Objects", EditorStyles.boldLabel);

        if (GUILayout.Button("Select"))
        {
            SelectObjects();
        }

    }
    static void SelectObjects()
    {
        // 获取当前选中的对象
        GameObject selectedObject = Selection.activeGameObject;

        if (selectedObject == null)
        {
            Debug.LogWarning("Please select an object with a Renderer component.");
            return;
        }

        // 获取选中对象的Renderer组件
        Renderer renderer = selectedObject.GetComponent<Renderer>();

        if (renderer == null)
        {
            Debug.LogWarning("The selected object does not have a Renderer component.");
            return;
        }

        // 获取材质
        Material material = renderer.sharedMaterial;

        if (material == null)
        {
            Debug.LogWarning("The selected object's Renderer does not have a material.");
            return;
        }

        // 查找所有使用相同材质的物体
        GameObject[] allObjects = FindObjectsOfType<GameObject>();
        List<GameObject> objectsWithSameMaterial = new List<GameObject>();

        foreach (GameObject obj in allObjects)
        {
            Renderer objRenderer = obj.GetComponent<Renderer>();

            if (objRenderer != null && objRenderer.sharedMaterial == material)
            {
                objectsWithSameMaterial.Add(obj);
            }
        }

        // 选择这些物体
        Selection.objects = objectsWithSameMaterial.ToArray();

        Debug.Log($"Selected {objectsWithSameMaterial.Count} objects with the same material.");
    }
}