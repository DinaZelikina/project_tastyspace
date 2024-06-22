import RoleBasedButtons from './RoleBasedButtons';
import CreateMenuQuestions from './menu/CreateMenuQuestions';
import Homepage from './homepage/Homepage';
import About from './about/About';
import ContactUs from './contact/ContactUs';
import { ActionButton } from './ActionButtons';

type GuestOptionsProps = {
  showRegistrationForm?: (role: string) => void;
  setCurrentComponent: (component: JSX.Element | null) => void; 
  setActionButtons: (buttons: ActionButton[]) => void;
};

export default function GuestOptions({ setCurrentComponent, setActionButtons }: GuestOptionsProps) {
  const handleCreateMenu = () => {
    setCurrentComponent(
      <CreateMenuQuestions 
        updateActionButtons={setActionButtons} 
        key={Date.now()} 
      />
    );
    setActionButtons([]);
  };
  
  const actions = {
    createMenu: handleCreateMenu,
    showHelp: () => {
      setCurrentComponent(<About />);
      setActionButtons([]); 
    },
    showContact: () => {
      setCurrentComponent(<ContactUs />); 
      setActionButtons([]); 
    },
    showHomepage: () => {
      setCurrentComponent(<Homepage />);
      setActionButtons([]);
    }
  };

  return (
    <>
      <RoleBasedButtons userRole="guest" actions={actions} />
    </>
  );
}
