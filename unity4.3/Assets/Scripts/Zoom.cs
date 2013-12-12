using UnityEngine;
using System.Collections;

public class Zoom : MonoBehaviour
{

	public float distance;
	public float sensitivityDistance = -7.5f;
	public float damping = 2.5f;
	public float min = -15;
	public float max = -2;
	private Vector3 zdistance;
	
	void  Start ()
	{
		distance = -10f;
		distance = transform.localPosition.z;
		zdistance = this.transform.localPosition;
	}
	void  Update ()
	{
		distance -= Input.GetAxis("Mouse ScrollWheel") * sensitivityDistance;
		distance = Mathf.Clamp(distance, min, max);
		zdistance.z = Mathf.Lerp(transform.localPosition.z, distance, Time.deltaTime * damping);
		transform.localPosition = zdistance;// new Vector3(transform.localPosition.x,transform.localPosition.y,zdistance.z);
	}
}
