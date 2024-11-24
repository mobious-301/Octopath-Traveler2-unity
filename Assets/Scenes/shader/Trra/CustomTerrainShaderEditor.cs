// using UnityEngine;
// using UnityEditor;
// using UnityEditor.Rendering.Universal.ShaderGUI;

// namespace UnityEditor.Rendering.Universal.ShaderGUI
// {
//     internal class CustomLitShader : BaseShaderGUI
//     {
//         private LitGUI.LitProperties litProperties;
//         private LitDetailGUI.LitProperties litDetailProperties;
//         private SavedBool m_DetailInputsFoldout;

//         public override void OnOpenGUI(Material material, MaterialEditor materialEditor)
//         {
//             base.OnOpenGUI(material, materialEditor);
//             m_DetailInputsFoldout = new SavedBool($"{headerStateKey}.DetailInputsFoldout", true);
//         }

//         public override void DrawAdditionalFoldouts(Material material)
//         {
//             m_DetailInputsFoldout.value = EditorGUILayout.BeginFoldoutHeaderGroup(m_DetailInputsFoldout.value, LitDetailGUI.Styles.detailInputs);
//             if (m_DetailInputsFoldout.value)
//             {
//                 LitDetailGUI.DoDetailArea(litDetailProperties, materialEditor);
//                 EditorGUILayout.Space();
//             }
//             EditorGUILayout.EndFoldoutHeaderGroup();
//         }

//         public override void FindProperties(MaterialProperty[] properties)
//         {
//             base.FindProperties(properties);
//             litProperties = new LitGUI.LitProperties(properties);
//             litDetailProperties = new LitDetailGUI.LitProperties(properties);

//             // 自定义属性
//             litProperties._DiffuseRemapScale0 = FindProperty("_DiffuseRemapScale0", properties);
//             litProperties._DiffuseRemapScale1 = FindProperty("_DiffuseRemapScale1", properties);
//             litProperties._DiffuseRemapScale2 = FindProperty("_DiffuseRemapScale2", properties);
//             litProperties._DiffuseRemapScale3 = FindProperty("_DiffuseRemapScale3", properties);
//             litProperties._EnableHeightBlend = FindProperty("_EnableHeightBlend", properties);
//             litProperties._HeightTransition = FindProperty("_HeightTransition", properties);
//             litProperties._NumLayersCount = FindProperty("_NumLayersCount", properties);
//             litProperties._Control = FindProperty("_Control", properties);
//             litProperties._Splat3 = FindProperty("_Splat3", properties);
//             litProperties._Splat2 = FindProperty("_Splat2", properties);
//             litProperties._Splat1 = FindProperty("_Splat1", properties);
//             litProperties._Splat0 = FindProperty("_Splat0", properties);
//             litProperties._Normal3 = FindProperty("_Normal3", properties);
//             litProperties._Normal2 = FindProperty("_Normal2", properties);
//             litProperties._Normal1 = FindProperty("_Normal1", properties);
//             litProperties._Normal0 = FindProperty("_Normal0", properties);
//             litProperties._Mask3 = FindProperty("_Mask3", properties);
//             litProperties._Mask2 = FindProperty("_Mask2", properties);
//             litProperties._Mask1 = FindProperty("_Mask1", properties);
//             litProperties._Mask0 = FindProperty("_Mask0", properties);
//             litProperties._Metallic0 = FindProperty("_Metallic0", properties);
//             litProperties._Metallic1 = FindProperty("_Metallic1", properties);
//             litProperties._Metallic2 = FindProperty("_Metallic2", properties);
//             litProperties._Metallic3 = FindProperty("_Metallic3", properties);
//             litProperties._Smoothness0 = FindProperty("_Smoothness0", properties);
//             litProperties._Smoothness1 = FindProperty("_Smoothness1", properties);
//             litProperties._Smoothness2 = FindProperty("_Smoothness2", properties);
//             litProperties._Smoothness3 = FindProperty("_Smoothness3", properties);
//             litProperties._MainTex = FindProperty("_MainTex", properties);
//             litProperties._BaseColor = FindProperty("_BaseColor", properties);
//             litProperties._TerrainHolesTexture = FindProperty("_TerrainHolesTexture", properties);
//             litProperties._EnableInstancedPerPixelNormal = FindProperty("_EnableInstancedPerPixelNormal", properties);
//         }

//         public override void MaterialChanged(Material material)
//         {
//             if (material == null)
//                 throw new ArgumentNullException("material");

//             SetMaterialKeywords(material, LitGUI.SetMaterialKeywords, LitDetailGUI.SetMaterialKeywords);
//         }

//         public override void DrawSurfaceOptions(Material material)
//         {
//             if (material == null)
//                 throw new ArgumentNullException("material");

//             // Use default labelWidth
//             EditorGUIUtility.labelWidth = 0f;

//             // Detect any changes to the material
//             EditorGUI.BeginChangeCheck();
//             if (litProperties.workflowMode != null)
//             {
//                 DoPopup(LitGUI.Styles.workflowModeText, litProperties.workflowMode, Enum.GetNames(typeof(LitGUI.WorkflowMode)));
//             }
//             if (EditorGUI.EndChangeCheck())
//             {
//                 foreach (var obj in blendModeProp.targets)
//                     MaterialChanged((Material)obj);
//             }
//             base.DrawSurfaceOptions(material);
//         }

//         public override void DrawSurfaceInputs(Material material)
//         {
//             base.DrawSurfaceInputs(material);
//             LitGUI.Inputs(litProperties, materialEditor, material);

//             // 自定义属性
//             EditorGUILayout.Space();
//             EditorGUILayout.LabelField("Custom Properties", EditorStyles.boldLabel);

//             // Diffuse Remap Scales
//             materialEditor.ShaderProperty(litProperties._DiffuseRemapScale0, "Diffuse Remap Scale 0");
//             materialEditor.ShaderProperty(litProperties._DiffuseRemapScale1, "Diffuse Remap Scale 1");
//             materialEditor.ShaderProperty(litProperties._DiffuseRemapScale2, "Diffuse Remap Scale 2");
//             materialEditor.ShaderProperty(litProperties._DiffuseRemapScale3, "Diffuse Remap Scale 3");

//             // Height Blend
//             materialEditor.ShaderProperty(litProperties._EnableHeightBlend, "Enable Height Blend");
//             if (litProperties._EnableHeightBlend.floatValue > 0)
//             {
//                 materialEditor.ShaderProperty(litProperties._HeightTransition, "Height Transition");
//             }

//             // Layer Count
//             materialEditor.ShaderProperty(litProperties._NumLayersCount, "Total Layer Count");

//             // Control and Splat Maps
//             materialEditor.ShaderProperty(litProperties._Control, "Control (RGBA)");
//             materialEditor.ShaderProperty(litProperties._Splat3, "Layer 3 (A)");
//             materialEditor.ShaderProperty(litProperties._Splat2, "Layer 2 (B)");
//             materialEditor.ShaderProperty(litProperties._Splat1, "Layer 1 (G)");
//             materialEditor.ShaderProperty(litProperties._Splat0, "Layer 0 (R)");

//             // Normal Maps
//             materialEditor.ShaderProperty(litProperties._Normal3, "Normal 3 (A)");
//             materialEditor.ShaderProperty(litProperties._Normal2, "Normal 2 (B)");
//             materialEditor.ShaderProperty(litProperties._Normal1, "Normal 1 (G)");
//             materialEditor.ShaderProperty(litProperties._Normal0, "Normal 0 (R)");

//             // Mask Maps
//             materialEditor.ShaderProperty(litProperties._Mask3, "Mask 3 (A)");
//             materialEditor.ShaderProperty(litProperties._Mask2, "Mask 2 (B)");
//             materialEditor.ShaderProperty(litProperties._Mask1, "Mask 1 (G)");
//             materialEditor.ShaderProperty(litProperties._Mask0, "Mask 0 (R)");

//             // Metallic and Smoothness
//             materialEditor.ShaderProperty(litProperties._Metallic0, "Metallic 0");
//             materialEditor.ShaderProperty(litProperties._Metallic1, "Metallic 1");
//             materialEditor.ShaderProperty(litProperties._Metallic2, "Metallic 2");
//             materialEditor.ShaderProperty(litProperties._Metallic3, "Metallic 3");
//             materialEditor.ShaderProperty(litProperties._Smoothness0, "Smoothness 0");
//             materialEditor.ShaderProperty(litProperties._Smoothness1, "Smoothness 1");
//             materialEditor.ShaderProperty(litProperties._Smoothness2, "Smoothness 2");
//             materialEditor.ShaderProperty(litProperties._Smoothness3, "Smoothness 3");

//             // Base Map and Color
//             materialEditor.ShaderProperty(litProperties._MainTex, "BaseMap (RGB)");
//             materialEditor.ShaderProperty(litProperties._BaseColor, "Main Color");

//             // Terrain Holes Texture
//             materialEditor.ShaderProperty(litProperties._TerrainHolesTexture, "Holes Map (RGB)");

//             // Instanced Per-Pixel Normal
//             materialEditor.ShaderProperty(litProperties._EnableInstancedPerPixelNormal, "Enable Instanced per-pixel normal");

//             DrawEmissionProperties(material, true);
//             DrawTileOffset(materialEditor, litProperties.baseMap);
//         }

//         public override void DrawAdvancedOptions(Material material)
//         {
//             if (litProperties.reflections != null && litProperties.highlights != null)
//             {
//                 EditorGUI.BeginChangeCheck();
//                 materialEditor.ShaderProperty(litProperties.highlights, LitGUI.Styles.highlightsText);
//                 materialEditor.ShaderProperty(litProperties.reflections, LitGUI.Styles.reflectionsText);
//                 if (EditorGUI.EndChangeCheck())
//                 {
//                     MaterialChanged(material);
//                 }
//             }

//             base.DrawAdvancedOptions(material);
//         }

//         public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
//         {
//             if (material == null)
//                 throw new ArgumentNullException("material");

//             // _Emission property is lost after assigning Standard shader to the material
//             // thus transfer it before assigning the new shader
//             if (material.HasProperty("_Emission"))
//             {
//                 material.SetColor("_EmissionColor", material.GetColor("_Emission"));
//             }

//             base.AssignNewShaderToMaterial(material, oldShader, newShader);

//             if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
//             {
//                 SetupMaterialBlendMode(material);
//                 return;
//             }

//             SurfaceType surfaceType = SurfaceType.Opaque;
//             BlendMode blendMode = BlendMode.Alpha;
//             if (oldShader.name.Contains("/Transparent/Cutout/"))
//             {
//                 surfaceType = SurfaceType.Opaque;
//                 material.SetFloat("_AlphaClip", 1);
//             }
//             else if (oldShader.name.Contains("/Transparent/"))
//             {
//                 surfaceType = SurfaceType.Transparent;
//                 blendMode = BlendMode.Alpha;
//             }

//             SetMaterialBlendMode(material, surfaceType, blendMode);
//         }
//     }
// }